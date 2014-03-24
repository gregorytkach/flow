ViewItems = classWithSuper(ViewBase, 'ViewItems')

function ViewItems.init(self, params)
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
    self._items = {}
    
end

function ViewItems.addItem(self, view)
    assert(view ~= nil)
    
    table.insert(self._items, view)
    
    self._sourceView:insert(view:sourceView())
end

function ViewItems.placeViews(self)
    ViewBase.placeViews(self)
    
    local viewsPositions = 
    {
        { x = 30, y = 170 },
        { x = 77, y = 170 },
        { x = 120, y = 183 },
        { x = 140, y = 215 },
        { x = 130, y = 250 },
        { x = 105, y = 280 },
        { x = 75, y = 305 },
        { x = 45, y = 333 },
        { x = 55, y = 370 },
        { x = 104, y = 380 },
        { x = 153, y = 381 },
        { x = 204, y = 381 },	
        { x = 253, y = 375 },	
        { x = 302, y = 368 },	
        { x = 352, y = 364 },	
        { x = 408, y = 364 },	
        { x = 455, y = 361 },	
        { x = 501, y = 348 },	
        { x = 522, y = 316 },	
        { x = 502, y = 283 },	
        { x = 458, y = 265 },	
        { x = 410, y = 263 },
        { x = 354, y = 261 },	
        { x = 310, y = 242 },	
        { x = 326, y = 206 },	
        { x = 502, y = 141 },
        { x = 528, y = 110 },
        { x = 492, y = 85 },
        { x = 447, y = 69 },	
        { x = 487, y = 46 },	
        { x = 535, y = 56 },	
        { x = 583, y = 62 },	
        { x = 631, y = 56 },	
        { x = 679, y = 53 },	
        { x = 727, y = 50 },	
        { x = 775, y = 57 },	
        { x = 776, y = 93 },	
        { x = 729, y = 99 },	
        { x = 681, y = 101 },	
        { x = 629, y = 112 },	
        { x = 821, y = 217 },	
        { x = 869, y = 229 },
        { x = 918, y = 240 },	
        { x = 968, y = 242 },	
        { x = 1018, y = 248 },	
        { x = 1056, y = 275 },	
        { x = 1053, y = 311 },	
        { x = 1012, y = 336 },	
        { x = 969, y = 357 },	
        { x = 929, y = 381 },	
        { x = 971, y = 402 },	
        { x = 1021, y = 412 },	
        { x = 1071, y = 415 },	
        { x = 1121, y = 416 },
        { x = 1171, y = 409 },	
        { x = 1220, y = 395 },	
        { x = 1243, y = 360 },	
        { x = 1232, y = 322 },	
        { x = 1238, y = 284 },	
        { x = 1276, y = 258 },	
        { x = 1325, y = 250 },	
        { x = 1375, y = 239 },	
        { x = 1427, y = 245 },	
        { x = 1491, y = 254 },
    }
    
    for i, view in ipairs(self._items)do
        local viewCoords = viewsPositions[i]
        
        view:placeViews()
        view:sourceView().x = viewCoords.x  + application.margin_left
        view:sourceView().y = viewCoords.y
        
        view:hide(0)
    end
    
end



