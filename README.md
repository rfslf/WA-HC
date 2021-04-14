# WA-HC
String and trigger for WeakAuras.
It will display castbars of all healers in raid on chosen tanks.
WA will catch events in CHAT_MSG_ADDON from healComm library and show healers castbars with source, destination, amount of healing, timeline of cast(switched off), spell name and icon.

Things you will need to do yourself:
1. Open WA and import string from file named "String"
2. Open dynamic group "Healers Casbars"
3. Go into the "Actions" tab and click the red "Expand" button
4. Find string:
 aura_env.targets={
    ['exampleTank1'] = true,
    ['exampleTank2'] = true,
}
5. Insert name of your tank/tanks in place instead 'exampleTank1'. 

Two dashes mean not execute string, this is comment!
If you choose many tanks it will be many castbars on screen and you may be confused.

<font color="red">IMPORTANT! Version 2.0.0 was not fully tested</font>
