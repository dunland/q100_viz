# q100_viz

Code für die Projektion und Bespielung des Monitors des CityScope-Setups in QUARREE100.

## q100viz_pygame

*q100viz_pygame* is a Python port of the *q100viz* Processing sketch, based on [pygame](https://www.pygame.org/).

Before you can run the sketch, you need to install required packages:
```
pip install -r requirements.txt
```

Geodata sources are expected to be found in the `data` directory. Create it (if it does not exist) and make the basemap image and shapefiles available.

Change to the `q100viz_pygame` directory and run the sketch:
```
python q100viz.py
```

### Interactions

- **M** key: toggle basemap
- **G** key: toggle grid
- **C** key: toggle calibration mode

- In calibration mode:
  - **TAB** key: select active corner
  - **UP/DOWN/LEFT/RIGHT** keys: move active corner
  - **S** key: save configuration

## Recommended folder structure

```
project qScope
└───cspy
│   └───CityScoPy LEGO Decoder
└───data
│       contains LINKS to GIS data from Seafile and api.json for SOFTWARE COMMUNICATION
└───q100_abm
│   │   GAMA workspace folder
│   └───Project_RuesdorferKamp_Network
│   │   │   Project 1: Social Agents Communication Network
│   │	└───RuesdorferKamp_Network_Model-01.gaml
│   └───Project_RuesdorferKamp_Restoration
│    	└───Restoration_Model_01.gaml
└───q100_info
│       infoscreen (JavaScript)
└───q100_viz
│       projection (Python)
└───settings
        initial setup data to initialize ALL SOFTWARE COMPONENTS centrally

```
where:
- cspy: https://github.com/dunland/cspy
- data: has to be linked from server
- q100_abm: https://github.com/quarree100/q100_abm
- q100_info: https://github.com/cqx931/q100_info
- q100_viz: https://github.com/dunland/q100_viz
- settings: t.b.a (currently from cspy/settings)
