class NavKey
    # TODO Make all this stuff configurable on a per instance basis (but not public)
    NAVKEY_CLASS = "nav-key"
    KEY_CLASS = "key-helper"
    KEY_ICON_CLASS = "key-icon"
    KEY_DESCRIPTION_CLASS = "key-desc"
    AVAILABLE_KEYS = [
        "up-down",
        "left-right",
        "enter",
        "return",
        "A", # RED
        "B", # TODO Document colors
        "C", #
        "D"  #
    ]

    constructor: (containerSelector, keyRef) ->
        $(containerSelector).append $("""
            <div class="#{NAVKEY_CLASS}">
            </div>
        """)
        @mainElem = $(".#{NAVKEY_CLASS}")
        for key in AVAILABLE_KEYS
            @mainElem.append $("""
                <div id="nav-#{key}" class="#{KEY_CLASS}">
                    <div class="#{KEY_ICON_CLASS}"></div>
                    <div class="#{KEY_DESCRIPTION_CLASS}"></div>
                </div>
            """)
        @hideAllKeys()
        for key of keyRef
            @showKey key, keyRef[key]

    show: ->
        @mainElem.show()

    hide: ->
        @mainElem.show()

    showKey: (key, description) ->
        $keyHelper = @mainElem.find(".#{KEY_CLASS}#nav-#{key}")
        $keyHelper.find(".#{KEY_DESCRIPTION_CLASS}").html description
        $keyHelper.show()

    hideAllKeys: ->
        @mainElem.find(".#{KEY_CLASS}").hide()

class Screen
    widgetAPI: new Common.API.Widget()
    tvKey: new Common.API.TVKeyValue()

    constructor: (fakeBodySelector) ->
        @fakeBodySelector = fakeBodySelector

    onLoad: ->
        log.debug "App.onLoad"
        @widgetAPI.sendReadyEvent()
        @enableKeys("keyListener")

    keyHandler: {}

    setKeyHandler: (handler) ->
        @keyHandler = handler
        @displayNavKey handler.keyRef if handler?.keyRef?

    enableKeys: (listenerId) ->
        $("##{listenerId}").focus()
    
    onKeyDown: (event) ->
        event = window.event if !event
        if typeof @keyHandler[event.keyCode] == "function"
            @keyHandler[event.keyCode] event
        log.trace "Key #{event.keyCode} pressed"

    displayNavKey: (keyRef) ->
        @navKey = new NavKey @fakeBodySelector, keyRef

    loadPage: (uri) ->
        document.location = uri

TVApp = {}
TVApp.Screen = Screen
window.TVApp = TVApp