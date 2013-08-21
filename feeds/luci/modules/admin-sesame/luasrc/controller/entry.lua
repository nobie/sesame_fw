module("luci.controller.entry", package.seeall)

function index()
	local page
	page = entry({"entry"},call("action_entry"),_("Entry"),1)
	page.dependent = true
	page.hidden = true
end


function action_entry()


	---local uci  = require "luci.model.uci".cursor()
	-- et=luci.http.getenv("HTTP_USER_AGENT")

	local uci = luci.model.uci.cursor()
	local uci_pass = uci:get("user","general","pass")

	local led = tonumber(luci.sys.exec("cat /sys/class/leds/tp-link\:blue\:system/brightness"))
	local led_st

	local btn = luci.http.formvalue("ledtoggle")
	local msg = ""

	if btn == "GO" then

	  if uci_pass == luci.http.formvalue("password") then 
	    if led == 0 then
	       luci.sys.exec("echo 255 > /sys/class/leds/tp-link\:blue\:system/brightness")
	       led_st = "ON"
	    else
	      luci.sys.exec("echo 0 > /sys/class/leds/tp-link\:blue\:system/brightness")
	      led_st = "OFF"
	    end
             msg="OK"

	  elseif uci_pass ~= "" then
	    if led == 0 then
	      	led_st = "OFF"
		  else
	    	  led_st = "ON"
	  	end

	      msg = "Denied!"
	  end 

	 elseif btn == "ON" then
	   if led == 0 then
	   
	    luci.sys.exec("echo 255 > /sys/class/leds/tp-link\:blue\:system/brightness")
	   end
	   led_st = "ON"

	 elseif btn == "OFF" then
	   if led ~= 0 then
	     luci.sys.exec("echo 0 > /sys/class/leds/tp-link\:blue\:system/brightness")
	   end
	   led_st = "OFF"

	 elseif btn == "Toggle" then

	  if led == 0 then
	     luci.sys.exec("echo 255 > /sys/class/leds/tp-link\:blue\:system/brightness")
	      led_st = "ON"
	  else
	     luci.sys.exec("echo 0 > /sys/class/leds/tp-link\:blue\:system/brightness")
	      led_st = "OFF"
	  end

	 else

	  if led == 0 then
	      led_st = "OFF"
	  else
	      led_st = "ON"
	  end

	end

	luci.template.render("mini/entry", {led_st=led_st, msg=msg, uci_pass=uci_pass})

end