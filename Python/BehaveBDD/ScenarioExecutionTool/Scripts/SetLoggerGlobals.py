
def set_global_EXECUTION_TIME(value):
    # global EXECUTION_TIME
    # EXECUTION_TIME = value
    print("Global time is set to: " + value)
    globals()["EXECUTION_TIME"] = value


def get_global_EXECUTION_TIME():
    if "EXECUTION_TIME" in globals():
        print("Global time is returned as: " + globals()["EXECUTION_TIME"])
        return globals()["EXECUTION_TIME"]
    else:
        print("Global time is returned as: None")
        return None


def set_global_EXECUTION_ID(value):
    global EXECUTION_ID
    EXECUTION_ID = value


def get_global_EXECUTION_ID():
    if "EXECUTION_ID" in globals():
        return EXECUTION_ID
    else:
        return None

