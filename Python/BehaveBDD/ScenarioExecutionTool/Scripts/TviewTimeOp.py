
import os
import requests
import xml.etree.ElementTree as ET
from datetime import datetime
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger
from Scripts.DataManager import fn_GetCurrentCommonTNPDate

Configuration = c.Configuration

PlatformCodeloc = Configuration['PlatformCodeloc']
CoreIssueURL = Configuration['CoreIssueURL']
    
def fn_SetDateInTview(Month, Date, Year,hour = None ,minute = None, second = None):
    MessageLogger.debug("Month -- " + Month)
    MessageLogger.debug("Date -- " + Date)
    MessageLogger.debug("Year -- " + Year)
    MessageLogger.debug("hour -- " + str(hour))
    MessageLogger.debug("minute -- " + str(minute))
    MessageLogger.debug("second -- " + str(second))
    TviewdateSetCmd = ""
    if len(Date) == 1:
        Date = "0"+Date
    if len(Month) == 1:
        Month = "0"+Month
        
    if hour is not None and minute is not None and second is not None:
        if len(hour) == 1:
            hour = "0"+hour
        if len(minute) == 1:
            minute = "0"+minute    
        if len(second) == 1:
            second = "0"+second   

        virtualtime = Month+"/"+Date+"/"+Year+ " "+hour +":" + minute +":" + second
        virtualtime1 = Month+"/"+Date+"/"+Year+ " "+hour +":" + minute +":" + second
        previousTime = fn_checkDBBAppTime()
        if previousTime is not None and virtualtime is not None:
            virtualtime = datetime.strptime(virtualtime, "%m/%d/%Y %H:%M:%S")
            if virtualtime > previousTime:
                virtualtime = virtualtime1
                TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
            else:
                MessageLogger.info(f"Tview time is already set to {previousTime}")
        else:
            MessageLogger.info(f"CI App Server not responding")
    else:
        virtualtime = Month+"/"+Date+"/"+Year
        print(virtualtime)
        TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
    if TviewdateSetCmd is not None:
        os.system(TviewdateSetCmd)


def fn_checkAgingDate(afterAgingDate):

    CurrentTnpDate = fn_GetCurrentCommonTNPDate()

    if afterAgingDate == CurrentTnpDate:
        return True

    if afterAgingDate <= CurrentTnpDate:
        MessageLogger.error(f"Current TnpDate is {CurrentTnpDate} is lesser or equal to after Aging Date {afterAgingDate} ")
        return True
    MessageLogger.debug(f"Current TnpDate is {CurrentTnpDate} after Aging Date {afterAgingDate}")
    return False


def fn_checkDBBAppTime():

    MessageLogger.info(f"Inside fn_checkDBBAppTime ")
    
    url_svcGetDateTimeNow = CoreIssueURL + '?User=bcadmin&Password=Test123!&dbbServiceName=svcGetDateTime&dbbSystemExtLogin=1'
    MessageLogger.info(f"URL : {url_svcGetDateTimeNow}")

    try:
        response = requests.get(url_svcGetDateTimeNow)
        if response.status_code == 200:
            xml_data = response.text
            MessageLogger.info(f"Resonse : {xml_data}")
            # Parse the XML
            root = ET.fromstring(xml_data)
            
            # Extract the DateTimeNow value
            datetime_str = root.find("DateTimeNow").text
            
            # Convert the string to a datetime object
            xml_datetime = datetime.strptime(datetime_str, "%m/%d/%Y %H:%M:%S")
            return xml_datetime
        else:
            print("Error:", response.status_code)
            return None
    except requests.exceptions.RequestException as e:
        print("Error:", e)
        return None
    
