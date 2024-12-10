import pyshark
import binascii
import re
import logging

logging.basicConfig(
    filename='/var/log/capture_http.log',
    level=logging.INFO,
    format='%(asctime)s - %(message)s'
)

interface = 'eth0'
capture_filter = 'tcp port 8004'

cap = pyshark.LiveCapture(interface=interface, bpf_filter=capture_filter)

def handle_packet(packet):
    try:
        if hasattr(packet, 'tcp') and hasattr(packet.tcp, 'payload'):
            raw_payload = packet.tcp.payload

            clean_payload = re.sub(r'[^0-9a-fA-F]', '', raw_payload)
            if len(clean_payload) % 2 != 0:
                clean_payload += '0'

            decoded_payload = binascii.unhexlify(clean_payload)
            decoded_string = decoded_payload.decode('utf-8', errors='replace')

            if hasattr(packet, 'ip'):
                src_ip = packet.ip.src
                dst_ip = packet.ip.dst
                src_port = packet.tcp.srcport
                dst_port = packet.tcp.dstport
                logging.info(f"src ip:port -> dst ip:port: {src_ip}:{src_port} -> {dst_ip}:{dst_port}")
            logging.info(f"\n{decoded_string}")
    except Exception as e:
        logging.error(f"Error processing packet: {e}")

cap.apply_on_packets(handle_packet)
