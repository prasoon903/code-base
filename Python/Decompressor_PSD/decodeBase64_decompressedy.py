import json
import base64
import gzip
import io

def hex_to_ascii(hex_string):
    if hex_string.startswith("0x"):
        hex_string = hex_string[2:]
    byte_array = bytes.fromhex(hex_string)
    ascii_string = byte_array.decode('ascii', errors='ignore')
    return ascii_string

def base64_decode(encoded_string):
    decoded_bytes = base64.b64decode(encoded_string)
    return decoded_bytes

def decompress_gzip(gzip_bytes):
    with gzip.GzipFile(fileobj=io.BytesIO(gzip_bytes)) as f:
        decompressed_data = f.read()
    return decompressed_data

def save_json_to_file(data, account_number):
    # Convert bytes to string (assuming data is in bytes)
    json_data = data.decode('utf-8')

    # Load string into a JSON object
    json_object = json.loads(json_data)

    # Construct filename using AccountNumber
    filename = f'AccountNumber_{account_number}.json'

    # Save the JSON object prettily
    with open(filename, 'w') as json_file:
        json.dump(json_object, json_file, indent=4)

def process_hex_file(input_file):
    with open(input_file, 'r') as file:
        for line in file:
            #hex_string = line.strip()  # Read each line and strip whitespace
            
            # Process the hex string
            #ascii_result = hex_to_ascii(hex_string)
            ##decoded_result = base64_decode(line.strip())
            #decompressed_data = decompress_gzip(line.strip())

            # Load the JSON data to extract the AccountNumber
            #json_data = decompressed_data.decode('utf-8')
            #json_object = json.loads(json_data)
			
            decoded_data = base64.b64decode(line.strip())
            with gzip.GzipFile(fileobj=BytesIO(decoded_data)) as gzip_file:
                decompressed_data = gzip_file.read()
                                        
            json_data = decompressed_data.decode('utf-8')
            json_object = json.loads(json_data)

            # Extract the AccountNumber
            account_number = json_object.get("AccountNumber")
            if account_number:
                # Save to file with the specific naming convention
                save_json_to_file(decompressed_data, account_number)
            else:
                print("AccountNumber not found in the JSON data.")

# Example usage
input_file = 'APIQueue.txt'  # Replace with your input file name containing hex strings
process_hex_file(input_file)
