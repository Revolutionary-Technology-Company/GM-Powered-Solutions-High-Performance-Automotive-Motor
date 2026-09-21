#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY - UNIVAC-IX REAL-TIME TRANSLATOR
# System Module: hex_native_univac_translator.py
# Core Logic: Down-converts 64-bit modern telemetry into 36-bit legacy words
# ==============================================================================

import sys
import time

class UnivacTranslator:
    def __init__(self):
        # Strict 36-bit word mask (Max value: 0x7FFFFFFFF, 68719476735)
        self.UNIVAC_36_BIT_MASK = 0x7FFFFFFFF
        
        # Operational code definitions for the Univac-IX Master Node
        self.OP_CODES = {
            "THROTTLE_AXIS": 0x1A0,  # Command code for acceleration vectors
            "CLUTCH_ENGAGED": 0x2B1, # Torque cut-off warning flag
            "INVERTER_FAULT": 0x7F0  # System-wide thermal/over-current trap
        }

    def sanitize_64bit_stream(self, hex_input: str) -> int:
        """
        Takes raw 64-bit hexadecimal data strings from optical network transceivers
        and casts them into isolated clean integers.
        """
        try:
            clean_hex = hex_input.strip().replace("0x", "")
            parsed_value = int(clean_hex, 16)
            return parsed_value & 0xFFFFFFFFFFFFFFFF
        except ValueError:
            # Drop malformed frames instantly to maintain zero-latency loop integrity
            return 0

    def downconvert_to_36bit(self, value_64bit: int, op_code_key: str) -> int:
        """
        Applies solid-state telemetry bit-shifting. Combines the specific 
        Univac operational header with the scaled sensor payload data.
        """
        if op_code_key not in self.OP_CODES:
            raise ValueError(f"Invalid operation target vector: {op_code_key}")
            
        op_header = self.OP_CODES[op_code_key]
        
        # Compress the data footprint: shift and isolate the payload within 36-bit boundaries
        compressed_payload = (value_64bit >> 28) & 0xFFFFFFF
        
        # Synthesize the final structural 36-bit word
        univac_word = (op_header << 24) | compressed_payload
        return univac_word & self.UNIVAC_36_BIT_MASK

    def format_for_mainframe(self, univac_word: int) -> str:
        """
        Outputs the translated 36-bit word as a clean, standardized 
        hexadecimal string ready for transmission over unhackable light pulses.
        """
        return f"0x{univac_word:09X}"

# Production verification test loop execution block
if __name__ == "__main__":
    translator = UnivacTranslator()
    print("=======================================================================")
    print("UNIVAC-IX 36-BIT REAL-TIME SIGNAL TRANSLATION ENGINE INITIALIZED")
    print("=======================================================================")
    
    # Simulate a live streaming 64-bit throttle input vector (Pedal pressed to 85% depth)
    simulated_64bit_telemetry = "0x7FFFFFFFABCDEF12"
    print(f"[INPUT] Modern 64-bit Optical Telemetry Stream: {simulated_64bit_telemetry}")
    
    # Process through the translator architecture
    raw_integer = translator.sanitize_64bit_stream(simulated_64bit_telemetry)
    univac_output = translator.downconvert_to_36bit(raw_integer, "THROTTLE_AXIS")
    formatted_pulse = translator.format_for_mainframe(univac_output)
    
    print(f"[OUTPUT] Native Translated 36-Bit Mainframe Word: {formatted_pulse}")
    print("=======================================================================")
