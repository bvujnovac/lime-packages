local network = require 'lime.network'
local utils = require 'lime.utils'
local openwrt_wan = require 'lime.hwd.openwrt_wan'
local test_utils = require 'tests.utils'

local uci

local COMPLETE_BOARD = {
    ["network"] = {
        ["lan"] = {
            ["ifname"] = "eth0",
            ["protocol"] = "static",
        },
        ["wan"] = {
            ["ifname"] = "eth1",
            ["protocol"] = "dhcp",
        },
    }
}

local NO_WAN_BOARD = {
    ["network"] = {
        ["lan"] = {
            ["ifname"] = "eth0",
            ["protocol"] = "static",
        },
    }
}

local NO_ETHERNET_BOARD = {}

describe('LiMe Network tests', function()

    it('test detect_hardware normal board', function()
        config.set('network', 'lime')
        config.set('network', 'protocols', {'lan'})
        stub(utils, "getBoardAsTable", function () return COMPLETE_BOARD end)
        uci:commit('lime')
        openwrt_wan.detect_hardware()
        assert.are.same({'wan'}, uci:get("lime", "lm_hwd_openwrt_wan", "protocols"))
        assert.is.equal('eth1', uci:get("lime", "lm_hwd_openwrt_wan", "linux_name"))
        assert.is.equal('true', uci:get("lime", "lm_hwd_openwrt_wan", "autogenerated"))
    end)

    it('test detect_hardware no wan board does not crash', function()
        config.set('network', 'lime')
        config.set('network', 'protocols', {'lan'})
        stub(utils, "getBoardAsTable", function () return NO_WAN_BOARD end)
        uci:commit('lime')
        openwrt_wan.detect_hardware()
        -- we are just making sure that detect_hardware does not crash
    end)

    it('test detect_hardware no ethernet board does not crash', function()
        config.set('network', 'lime')
        config.set('network', 'protocols', {'lan'})
        stub(utils, "getBoardAsTable", function () return NO_ETHERNET_BOARD end)
        uci:commit('lime')
        openwrt_wan.detect_hardware()
        -- we are just making sure that detect_hardware does not crash
    end)

    before_each('', function()
        uci = test_utils.setup_test_uci()
    end)

    after_each('', function()
        test_utils.teardown_test_uci(uci)
    end)

end)
