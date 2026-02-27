import datetime
import json
import os


class TrafficLogger:
    def __init__(self, log_dir=None):
        if log_dir is None:
            log_dir = os.path.join(
                os.environ.get("LOCALAPPDATA", os.path.expanduser("~")),
                "ONTProxy", "logs"
            )
        os.makedirs(log_dir, exist_ok=True)
        self.log_dir = log_dir
        ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        self.log_file = os.path.join(log_dir, f"traffic_{ts}.jsonl")
        self._fh = open(self.log_file, "a", encoding="utf-8")
        print(f"[+] Traffic log: {self.log_file}")

    def __del__(self):
        self.close()

    def log_request(self, flow_id, method, url, headers, body=None):
        entry = {
            "type": "request",
            "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "flow_id": flow_id,
            "method": method,
            "url": url,
            "headers": dict(headers) if headers else {},
        }
        if body:
            try:
                entry["body"] = body.decode("utf-8", errors="replace")
            except AttributeError:
                entry["body"] = str(body)
        self._fh.write(json.dumps(entry, ensure_ascii=False) + "\n")
        self._fh.flush()

    def log_response(self, flow_id, status_code, headers, body=None, modified=False):
        entry = {
            "type": "response",
            "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "flow_id": flow_id,
            "status_code": status_code,
            "headers": dict(headers) if headers else {},
            "modified": modified,
        }
        if body:
            try:
                entry["body_preview"] = body[:2048].decode("utf-8", errors="replace")
            except (AttributeError, TypeError):
                entry["body_preview"] = str(body)[:2048]
        self._fh.write(json.dumps(entry, ensure_ascii=False) + "\n")
        self._fh.flush()

    def close(self):
        if self._fh and not self._fh.closed:
            self._fh.close()
