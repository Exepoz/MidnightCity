- Author : Wert
- Description : General ambulance job

# Important config values
Config.ReviveClientEvent = 'hospital:client:Revive' --# change your revive event this is default qb-core event 

# Extra depends
- interact-sound (https://github.com/plunkettscott/interact-sound)
- xsound (https://github.com/Xogy/xsound)

# Install
- Open #Add items file and add items your item list.
- Open #Add sound file and add sounds your interact-sound script.
- Open #Add sql file and upload your database.

# Items

["bloodbag"] = {
    ["name"] = "bloodbag", 			 	
    ["label"] = "Blood Bag", 	    
    ["weight"] = 150, 		
    ["type"] = "item", 
    ["image"] = "bloodbag.png", 	    	
    ["unique"] = true,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},

["bloodtube"] = {
    ["name"] = "bloodtube", 			 	
    ["label"] = "Blood Tube", 	    
    ["weight"] = 500, 		
    ["type"] = "item", 
    ["image"] = "bloodtupe.png", 	    	
    ["unique"] = true,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},


["emptybaggy"] = {
    ["name"] = "emptybaggy", 			 	
    ["label"] = "Empty Blood Bag", 	    
    ["weight"] = 100, 		
    ["type"] = "item", 
    ["image"] = "emptybaggy.png", 	    	
    ["unique"] = false,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},

["emptysyringe"] = {
    ["name"] = "emptysyringe", 			 	
    ["label"] = "Empty Syringe", 	    
    ["weight"] = 50, 		
    ["type"] = "item", 
    ["image"] = "emptysyringe.png", 	    	
    ["unique"] = false,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,
    ["description"] = ""
},

["emptytube"] = {
    ["name"] = "emptytube", 			 	
    ["label"] = "Empty Tube", 	    
    ["weight"] = 50, 		
    ["type"] = "item", 
    ["image"] = "emptytube.png", 	    	
    ["unique"] = false,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},

["kankart"] = {
    ["name"] = "kankart", 			 	
    ["label"] = "Person Blood Card", 	    
    ["weight"] = 50, 		
    ["type"] = "item", 
    ["image"] = "kankart.png", 	    	
    ["unique"] = true,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},

["mri"] = {
    ["name"] = "mri", 			 	
    ["label"] = "MRI Document", 	    
    ["weight"] = 150, 		
    ["type"] = "item", 
    ["image"] = "mri.png", 	    	
    ["unique"] = true,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},

["xray"] = {
    ["name"] = "xray", 			 	
    ["label"] = "Xray Document", 	    
    ["weight"] = 150, 		
    ["type"] = "item", 
    ["image"] = "xray.png", 	    	
    ["unique"] = true,   	
    ["useable"] = true, 	
    ["shouldClose"] = true,    
    ["combinable"] = nil,   
    ["description"] = ""
},