Config = {}

-- you can get interior ID by standing inside , and use the below command
-- it will be shown in your F8 console
Config.getInteriorID_command = "getintid" -- leave it empty to disable it

-- default values for disabling interior sprinting/jumping
Config.default = {
    disableSprintInInterior = true,             -- can't sprint
    disableJumpInInterior = true                -- can't jump
}

-- only works for ESX based servers (it will automatically check if ESX is available)
Config.excludeForJobs = {

    [137473] = {    -- interior ID  [ this is police department ]
        police = {  -- job name
            disableSprintInInterior = false,    -- can sprint
            disableJumpInInterior = true        -- can't jump
        },
    },
}

-- this will override excludeForJobs
Config.excludePed = {
    -- player_one is franklin character
    [`player_one`] = {  -- Ped Name ( https://docs.fivem.net/docs/game-references/ped-models/ ) [[it should be between ` ` not ' ' or " " ]]

        [196609] = {    -- interior ID  [ this is bennys workshop ]
            disableSprintInInterior = true,    -- can sprint
            disableJumpInInterior = false        -- can't jump
        },
    },
}

Config.debugmode = false -- this will impact usage a little but, make sure to disable it if you dont want it