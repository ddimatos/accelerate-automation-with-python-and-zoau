import argparse

def main():
    # Create the ArgumentParser
    parser = argparse.ArgumentParser(description="This utility will find the" \
    "differences and by default will concatenate the compared-dataset to the src-dataset.")

    # Options
    parser.add_argument("-r", "--reverse", action='store_true', help="Enter true to reverse the contamination order.")
    parser.add_argument('src_dataset', type=str, help='The source dataset to be used in diffing.')
    parser.add_argument('change_dataset', type=str, help='The change dataset to be used in diffing.')
    parser.add_argument('merge_dataset', type=str, nargs='?', help='The merge dataset to contain all diffing and no duplicates.')

    # Parse the arguments
    args = parser.parse_args()
    
    # Access the provided arguments
    if args.reverse:
        print("Detected -r (reverse)")
    if args.src_dataset:
        print(f"Detected src_dataset, {args.src_dataset}")
    if args.change_dataset:
        print(f"Detected change_dataset, {args.change_dataset}")
    if args.merge_dataset:
        print(f"Detected merge_dataset, {args.merge_dataset}")

if __name__ == "__main__":
    main()



