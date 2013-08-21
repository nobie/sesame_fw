module("luci.controller.entry", package.seeall)

function index()
local page
page = entry({"entry"},template("mini/entry"),_("user interface"),1)
page.dependent = true
page.hidden = true

end
