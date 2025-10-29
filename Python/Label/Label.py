class Label:
    import os
    from SetUp import SetUp
    import glob
    import shutil
    import argparse
    from pathlib import Path

    A1 = SetUp()
    parser = argparse.ArgumentParser()

    SERVERNAME = A1.SERVERNAME
    DSLCopyingPath = A1.DSLCopyingPath

    print("SCRIPT FOR TAKING LABEL FROM THE LOCATION AND DB RESTORE")

    LabelVersion = input("ENTER THE LABEL VERSION: ")

    LabelPath = "\\\\" + SERVERNAME + "\\" + "Labels\BANKCARD\CreditProcessing\Labels\CreditProcessing_"

    DSLPath = LabelPath + LabelVersion + "\\" + "Application\DSL"

    # parser.add_argument(DSLPath)

    # DSLPath = str(parser.parse_args())

    # DSLCopyingPath = DSLCopyingPath + "\\"

    DSLCopyingPath = os.path.join(DSLCopyingPath, os.path.basename(LabelVersion))
    print(DSLCopyingPath)
    # DSLCopyingPath = DSLCopyingPath + LabelVersion

    if not os.path.exists(DSLCopyingPath):
        print("Path doesn't exist. trying to folder")
        os.makedirs(DSLCopyingPath)

    shutil.copytree(DSLPath, DSLCopyingPath)


'''
    DBOption = input("Press 1 for PLAT and 2 for NewShrunk: ")

    if DBOption == 1:
        DB = "PLAT"
    elif DBOption == 2:
        DB = "1NewShrunk"
    else:
        print("Invalid Option")

    DBPath = LabelPath + LabelVersion + ""

'''