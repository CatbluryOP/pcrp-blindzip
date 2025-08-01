# pcrp-blindzip



# qb-inventory

```lua
["ziptie"] = {
    ["name"] = "ziptie",
    ["label"] = "Ziptie",
    ["weight"] = 100,
    ["type"] = "item",
    ["image"] = "ziptie.png",
    ["unique"] = false, -- single-use, no metadata needed
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Plastic tie to restrain someone. One-time use."
},

["blindfold"] = {
    ["name"] = "blindfold",
    ["label"] = "Blindfold",
    ["weight"] = 150,
    ["type"] = "item",
    ["image"] = "blindfold.png",
    ["unique"] = true, -- to track remaining uses (metadata)
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Blocks vision of the person in front of you. Can be reused up to 5 times."
},

["scissors"] = {
    ["name"] = "scissors",
    ["label"] = "Scissors",
    ["weight"] = 200,
    ["type"] = "item",
    ["image"] = "scissors.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Can cut zipties or remove a blindfold from someone."
},
```


# tgiann-inventory

```lua
ziptie = {
    name = "ziptie",
    label = "Ziptie",
    weight = 100,
    type = "item",
    image = "ziptie.png",
    unique = false, -- one-time use, so no need to track metadata
    useable = true,
    shouldClose = true,
    description = "Plastic tie to restrain someone's hands. Single use."
},

blindfold = {
    name = "blindfold",
    label = "Blindfold",
    weight = 150,
    type = "item",
    image = "blindfold.png",
    unique = true, -- needed for tracking uses
    useable = true,
    shouldClose = true,
    description = "Blocks a player's vision. Can be used up to 5 times."
},

scissors = {
    name = "scissors",
    label = "Scissors",
    weight = 200,
    type = "item",
    image = "scissors.png",
    unique = false,
    useable = true,
    shouldClose = true,
    description = "Used to cut zipties or remove blindfolds."
},
```
