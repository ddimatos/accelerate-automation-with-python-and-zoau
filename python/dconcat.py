from zoautil_py import datasets
import argparse

def dconcat(source: str = None, change:str = None, merge: str = None, reverse: bool = False):
   """
   This utility will find the differences between two datasets will concatenate the
   changes to the source dataset (default).
   The default behavior can be reversed to append the changes found to the changes
   dataset.
   If a merge dataset is provided, all changes will be inserted into the merge
   data leaving out any duplicates.

   Parameters
   ----------
   source (str): Source dataset containing the original listing.  
   change (str): Changes dataset containing the updated listing to be compared
   to source dataset.  
   merge (str): Dataset to contain the differences for both datasets.  
   reverse: (bool): Change the default behavior to write the source changes
   into the changes dataset.  
   """

   # Always compare DS1 and DS2 and process further accordingly.
   if source is not None and change is not None:
      result=datasets.compare(source, change)
      lines = result.split('\n')

      source_lines = []
      for line in lines:
         if line.startswith("I -"):
            source_lines.append(line[4:84])

      change_lines = []
      for line in lines:
         if line.startswith("D -"):
            change_lines.append(line[4:84])

      if merge is not None:
         # Case: DS1 and DS2 are diffed and inserted into DS3
         # TODO: Consider optimizing as two writes instead of iterating.
         for source_line in source_lines:
            datasets.write(merge, source_line, True)

         for change_line in change_lines:
            datasets.write(merge, change_line, True)
      elif reverse:
         # Case: DS1 and DS2 are diffed and inserted into DS2 (reverse order)
         for change_line in change_lines:
            datasets.write(change, change_line, True)
      else:
         # Case: DS1 and DS2 are diffed and inserted into DS1
         for source_line in source_lines:
            datasets.write(source, source_line, True)

def main():
    # Create the ArgumentParser
    parser = argparse.ArgumentParser(description="This utility will find the" \
    "differences and by default will concatenate the compared-dataset to the src-dataset.")

    # Options
    parser.add_argument("-r", "--reverse", action='store_true', help="Enter true to reverse the contamination order.")
    parser.add_argument('source', type=str, help='The source dataset to be used in diffing.')
    parser.add_argument('change', type=str, help='The change dataset to be used in diffing.')
    parser.add_argument('merge', type=str, nargs='?', help='The merge dataset to contain all diffing and no duplicates.')

    # Parse the arguments
    args = parser.parse_args()

    # Access the provided arguments
    if args.reverse:
         dconcat(source=args.source, change=args.change, reverse = True)
    elif args.merge:
         dconcat(source=args.source, change=args.change, merge=args.merge)
    else:
         dconcat(source=args.source, change=args.change)

if __name__ == "__main__":
    main()
