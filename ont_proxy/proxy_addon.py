import uuid

from mitmproxy import http

from . import response_modifier
from .traffic_logger import TrafficLogger


class ONTProxyAddon:
    def __init__(self, log_dir=None):
        self.logger = TrafficLogger(log_dir=log_dir)

    def request(self, flow: http.HTTPFlow):
        if not response_modifier.should_intercept(flow.request.pretty_host):
            return
        flow.metadata["ont_flow_id"] = str(uuid.uuid4())[:8]
        self.logger.log_request(
            flow_id=flow.metadata["ont_flow_id"],
            method=flow.request.method,
            url=flow.request.pretty_url,
            headers=flow.request.headers,
            body=flow.request.get_content(),
        )

    def response(self, flow: http.HTTPFlow):
        if not response_modifier.should_intercept(flow.request.pretty_host):
            return

        flow_id = flow.metadata.get("ont_flow_id", "unknown")
        content_type = flow.response.headers.get("content-type", "")
        modified = False

        if any(ct in content_type for ct in ["text/html", "text/asp", "application/javascript", "text/javascript", "text/xml"]):
            body = flow.response.get_text()
            if body:
                new_body = response_modifier.modify_response_body(
                    body, url_path=flow.request.path
                )
                if new_body != body:
                    flow.response.set_text(new_body)
                    modified = True

        response_modifier.modify_response_headers(flow.response.headers)

        self.logger.log_response(
            flow_id=flow_id,
            status_code=flow.response.status_code,
            headers=flow.response.headers,
            body=flow.response.get_content(),
            modified=modified,
        )

    def done(self):
        self.logger.close()


addons = [ONTProxyAddon()]
