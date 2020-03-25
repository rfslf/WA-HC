# WA-HC
String and trigger for WeakAuras.
It will display castbars of chosen healers on chosen tanks.
WA will catch events in CHAT_MSG_ADDON from healComm library and show healers castbars with soucre, destination, amount of healing, timeline of cast, spell name and icon.

Things you need to do yorself
1. Open WA and import string from file named "String"
2. Open dynamic group "Heal Castbars"
3. Open tabframe Trigger
4. Open code of Trigger
5. Find string with healers:
    <div>healers = {</div>
        <div>--["4474-01B77F35"] = "Virgo",</div>
        <div>v["4474-01B77F36"] = "YourHealer"</div>
    }
6. Insert GUID and name of your healers in that format. 
You can discower GUID when you in group or raid with them via command /script print(UnitGUID("target")) by selecting them in target. 
Command will write  GUID in defaul chat.
Two dashes mean not execute string, this is comment!
7. Find string with tank:
    tanks = {</div>
        <div>-- ["4474-01B77F35"] = "Virgo",</div>
        <div>["4474-01B77F37"] = "YourTank"</div>
    } 
 8. Insert your main tank OR offtank like in step 6. 
 If you chose many tanks it will be many castbars on screen and you may be confused.
