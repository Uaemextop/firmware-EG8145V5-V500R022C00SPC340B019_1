import argparse
import os
import sys
import threading

from mitmproxy.options import Options
from mitmproxy.tools.dump import DumpMaster

from .cert_manager import generate_ca, install_ca_windows, uninstall_ca_windows
from .chrome_launcher import launch_chrome, cleanup_profile
from .proxy_addon import ONTProxyAddon


def run_proxy(listen_host="127.0.0.1", listen_port=8080, ca_cert_dir=None):
    ca_key, ca_cert, ca_key_path, ca_cert_path = generate_ca(ca_cert_dir)
    print(f"[+] CA certificate: {ca_cert_path}")

    opts = Options(
        listen_host=listen_host,
        listen_port=listen_port,
        ssl_insecure=True,
    )

    master = DumpMaster(opts)
    addon = ONTProxyAddon()
    master.addons.add(addon)

    print(f"[+] Proxy listening on {listen_host}:{listen_port}")
    print(f"[+] Intercepting traffic to 192.168.100.1")
    print(f"[+] Press Ctrl+C to stop")

    try:
        master.run()
    except KeyboardInterrupt:
        print("\n[+] Shutting down proxy...")
        master.shutdown()
    finally:
        addon.done()


def main():
    parser = argparse.ArgumentParser(
        prog="ont_proxy",
        description="Huawei ONT EG8145V5 traffic interception proxy for Megacable",
    )
    subparsers = parser.add_subparsers(dest="command")

    start_parser = subparsers.add_parser("start", help="Start proxy and launch Chrome")
    start_parser.add_argument("--host", default="127.0.0.1", help="Proxy listen address")
    start_parser.add_argument("--port", type=int, default=8080, help="Proxy listen port")
    start_parser.add_argument("--target", default="http://192.168.100.1", help="ONT web interface URL")
    start_parser.add_argument("--no-chrome", action="store_true", help="Don't launch Chrome automatically")
    start_parser.add_argument("--no-install-cert", action="store_true", help="Skip CA certificate installation")

    cert_parser = subparsers.add_parser("install-cert", help="Install CA certificate in Windows root store")
    cert_parser = subparsers.add_parser("uninstall-cert", help="Remove CA certificate from Windows root store")

    subparsers.add_parser("cleanup", help="Remove Chrome profile and generated files")

    args = parser.parse_args()

    if args.command == "start":
        _, _, _, ca_cert_path = generate_ca()

        if not args.no_install_cert:
            install_ca_windows(ca_cert_path)

        if not args.no_chrome:
            chrome_thread = threading.Thread(
                target=launch_chrome,
                kwargs={
                    "proxy_host": args.host,
                    "proxy_port": args.port,
                    "target_url": args.target,
                },
                daemon=True,
            )
            chrome_thread.start()

        run_proxy(listen_host=args.host, listen_port=args.port)

    elif args.command == "install-cert":
        _, _, _, ca_cert_path = generate_ca()
        install_ca_windows(ca_cert_path)

    elif args.command == "uninstall-cert":
        uninstall_ca_windows()

    elif args.command == "cleanup":
        cleanup_profile()
        uninstall_ca_windows()

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
