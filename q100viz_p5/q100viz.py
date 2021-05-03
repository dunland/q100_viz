import pathlib
import p5
import random

import gis
import grid

path = pathlib.Path()

# geodata sources
BASEMAP_FILE = path.joinpath("../data/Layer/180111-QUARREE100-RK_modifiziert_smaller.tga")
BUILDINGS_FILE = path.joinpath("../data/Shapefiles/osm_heide_buildings.shp")
WAERMESPEICHER_FILE = path.joinpath("../data/Shapefiles/Wärmespeicher.shp")
HEIZZENTRALE_FILE = path.joinpath("../data/Shapefiles/Heizzentrale.shp")
NAHWAERMENETZ_FILE = path.joinpath("../data/Shapefiles/Nahwärmenetz.shp")
TYPOLOGIEZONEN_FILE = path.joinpath("../data/Shapefiles/Typologiezonen.shp")

# size (should match the resolution of the projector)
canvas_size = (1920, 1080)

# mapping from screen coordinates to corner points of the area of interest
topleft = [1920, 60]
topright = [1920, 1020]
bottomright = [0, 1020]
bottomleft = [0, 60]

_gis = None

# bounding box (EPSG:3857) of the area of interest
viewport_extent = (1013102, 7206177, 1013936, 7207365)

# bounding box (EPSG:3857) of the aerial photo
basemap_extent = (1012695, 7205976, 1014205, 7207571)

# GIS layers (as GeoDataFrame)
typologiezonen = None
buildings = None
waermezentrale = None
nahwaermenetz = None

_grid = None

# other configuration values
show_basemap = True
show_shapes = True


def setup():
    global _gis
    global _grid
    global typologiezonen, buildings, waermezentrale, nahwaermenetz

    # initialize canvas before everything else, to make sure the actual width and height values are used
    p5.size(*canvas_size)

    # ======= GIS setup =======
    _gis = gis.GIS(viewport_extent, [topleft, topright, bottomright, bottomleft])

    # load basemap
    _gis.load_basemap(BASEMAP_FILE, basemap_extent)

    # load shapefiles into data frames
    buildings = gis.read_shapefile(BUILDINGS_FILE)
    typologiezonen = gis.read_shapefile(TYPOLOGIEZONEN_FILE)
    nahwaermenetz = gis.read_shapefile(NAHWAERMENETZ_FILE)
    waermezentrale = gis.read_shapefile(WAERMESPEICHER_FILE, 'Wärmespeicher').append(gis.read_shapefile(HEIZZENTRALE_FILE))

    # insert some random values
    buildings['co2'] = [random.random() for row in buildings.values]

    print(buildings.head())
    print(typologiezonen.head())
    print(nahwaermenetz.head())
    print(waermezentrale.head())

    # ======= Grid setup =======
    _grid = grid.Grid((11, 11), [[80, 60], [1080, 60], [1080, 1060], [80, 1060]])


def draw():
    p5.background(0)

    with p5.push_matrix():
        # apply the transformation matrix
        mat = _gis.surface.get_transform_mat()
        p5.apply_matrix(mat)

        # GIS shapes and objects
        if show_basemap:
            _gis.draw_basemap()

        if show_shapes:
            _gis.draw_polygon_layer(buildings, 0, 1, p5.Color(96, 205, 21), p5.Color(213, 50, 21), 'co2')
            _gis.draw_polygon_layer(typologiezonen, 0, 1, p5.Color(123, 201, 230, 50))
            _gis.draw_linestring_layer(nahwaermenetz, p5.Color(217, 9, 9), 3)
            _gis.draw_polygon_layer(waermezentrale, 0, 1, p5.Color(252, 137, 0))

        # reference frame
        p5.stroke(255, 255, 0)
        p5.stroke_weight(2)
        p5.no_fill()
        p5.rect(0, 0, width, height)

    with p5.push_matrix():
        # apply the transformation matrix
        mat = _grid.surface.get_transform_mat()
        p5.apply_matrix(mat)

        # grid
        _grid.draw(p5.Color(255, 255, 255), 1, p5.Color(0, 0, 0, 0))

        # reference frame
        p5.stroke(0, 0, 255)
        p5.stroke_weight(2)
        p5.no_fill()
        p5.rect(0, 0, width, height)


if __name__ == '__main__':
    p5.run(frame_rate=1)