# EZ Gates by Tomerxp
doorlock configuration setup

![showcase](https://github.com/Tomerxp/FiveM-gates/blob/main/showcase.gif?raw=true)

### NUI_doorlock (gateid) must have same name as configured in config.lua and these attributes -
```
Config.DoorList['lilseoul'] = {
	event = true,
    objCoords = vec3(-667.669983, -895.640015, 23.508533),
    objHeading = 269.77996826172,
    objHash = -1483471451,
    oldMethod = false,
    slides = true,
    ...
    ....
    .....
}
```

### Add this to doorlock - setstate

```
        if Config.DoorList[doorID].event then
            TriggerEvent("gates:server:togglegate", doorID, locked)
        end
```

### todo
- On first load, sync current gate status