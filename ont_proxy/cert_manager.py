import datetime
import os
import subprocess
import sys

from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.x509.oid import NameOID


def get_cert_dir():
    base = os.path.join(os.environ.get("LOCALAPPDATA", os.path.expanduser("~")), "ONTProxy")
    os.makedirs(base, exist_ok=True)
    return base


def generate_ca(cert_dir=None):
    cert_dir = cert_dir or get_cert_dir()
    ca_key_path = os.path.join(cert_dir, "ont_proxy_ca.key")
    ca_cert_path = os.path.join(cert_dir, "ont_proxy_ca.pem")

    if os.path.exists(ca_key_path) and os.path.exists(ca_cert_path):
        with open(ca_key_path, "rb") as f:
            ca_key = serialization.load_pem_private_key(f.read(), password=None)
        with open(ca_cert_path, "rb") as f:
            ca_cert = x509.load_pem_x509_certificate(f.read())
        return ca_key, ca_cert, ca_key_path, ca_cert_path

    ca_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)

    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, "MX"),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, "Jalisco"),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "ONT Proxy CA"),
        x509.NameAttribute(NameOID.COMMON_NAME, "ONT Proxy Root CA"),
    ])

    ca_cert = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(issuer)
        .public_key(ca_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(datetime.datetime.now(datetime.timezone.utc))
        .not_valid_after(datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=3650))
        .add_extension(x509.BasicConstraints(ca=True, path_length=None), critical=True)
        .add_extension(
            x509.KeyUsage(
                digital_signature=True,
                key_cert_sign=True,
                crl_sign=True,
                content_commitment=False,
                key_encipherment=False,
                data_encipherment=False,
                key_agreement=False,
                encipher_only=False,
                decipher_only=False,
            ),
            critical=True,
        )
        .sign(ca_key, hashes.SHA256())
    )

    with open(ca_key_path, "wb") as f:
        f.write(ca_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.TraditionalOpenSSL,
            encryption_algorithm=serialization.NoEncryption(),
        ))

    with open(ca_cert_path, "wb") as f:
        f.write(ca_cert.public_bytes(serialization.Encoding.PEM))

    return ca_key, ca_cert, ca_key_path, ca_cert_path


def install_ca_windows(ca_cert_path):
    safe_path = os.path.normpath(os.path.abspath(ca_cert_path))
    ps_cmd = (
        f"Import-Certificate -FilePath '{safe_path}' "
        f"-CertStoreLocation Cert:\\LocalMachine\\Root"
    )
    escaped_cmd = ps_cmd.replace("'", "''")
    try:
        subprocess.run(
            ["powershell", "-Command", f"Start-Process powershell -Verb RunAs -ArgumentList '-Command {escaped_cmd}'"],
            check=True,
        )
        print(f"[+] CA certificate installed in Windows root store: {ca_cert_path}")
    except subprocess.CalledProcessError:
        print("[-] Failed to install CA certificate. Try running as Administrator.")
        print(f"    Manual command: powershell -Command \"{ps_cmd}\"")


def uninstall_ca_windows():
    ps_cmd = (
        "Get-ChildItem Cert:\\LocalMachine\\Root | "
        "Where-Object { $_.Subject -like '*ONT Proxy Root CA*' } | "
        "Remove-Item"
    )
    try:
        subprocess.run(
            ["powershell", "-Command", f"Start-Process powershell -Verb RunAs -ArgumentList '-Command {ps_cmd}'"],
            check=True,
        )
        print("[+] CA certificate removed from Windows root store")
    except subprocess.CalledProcessError:
        print("[-] Failed to remove CA certificate. Try running as Administrator.")


if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else "install"
    if action == "uninstall":
        uninstall_ca_windows()
    else:
        _, _, key_path, cert_path = generate_ca()
        print(f"[+] CA key:  {key_path}")
        print(f"[+] CA cert: {cert_path}")
        install_ca_windows(cert_path)
