\encoding{UTF-8}
\name{toGeoJSON}
\alias{toGeoJSON}
\alias{tg}
\title{Create GeoJSON file from spatial data}
\description{Creates a GeoJSON file from data frame, Spatial object or an external spatial data file.}
\usage{
toGeoJSON(data, name, dest, lat.lon, overwrite=TRUE)
tg(data, name, dest, lat.lon, overwrite=TRUE)
}
\arguments{
  \item{data}{Spatial data: \code{data.frame} (or \code{dplyr:tbl_df}) with at least two columns, representing the point coordinates, \code{Spatial} object (\code{sp} package) or path to external spatial data file as string. See below for details.}
  \item{name}{Name of the resulting GeoJSON file, as string. Optional -- if missing, the name of the data frame or data file is used.}
  \item{dest}{Directory the file shall be saved to, as string. Optional -- if missing, the current working directory is used.}
  \item{lat.lon}{For data frame conversion only. Names or indices of the columns in \code{data} containing the coordinates, as vector of two: \code{c(latitude, longitude)}. Optional -- if missing, \code{toGeoJSON} tries to detect them by name or takes the first two columns.}
  \item{overwrite}{\code{TRUE} (which is the default) overwrites existing files with the same name.}
}
\details{
\code{toGeoJSON} can handle three types of spatial data: a simple \code{data.frame}, \code{Spatial} objects and external spatial data files.

\emph{\code{data.frame} objects}

Point data might be available as simple \code{data.frame} or \code{tbl_df} (see \code{dplyr} package) objects. The \code{data.frame} must contain latitudes and longitudes in two separate columns and optionally may contain data columns.

\emph{\code{Spatial} objects}

\code{Spatial} objects (\code{sp} package) should have geographical coordinates (longlat, WGS84). If other projections are used, \code{toGeoJSON} can transform the coordinates on the fly, using the \code{rgdal} package.

\emph{Conversion of external spatial data files}

\code{toGeoJSON} uses the Ogre web API (\url{http://ogre.adc4gis.com}). See the \href{http://ogre.adc4gis.com}{Ogre} website for a list of supported formats. Please note that for Shapefiles, MapInfo and VRT, Ogre only accepts a zip file. The Ogre API does not support large files (>15 MB). Have a look at the \code{rgdal} package and its \code{writeOGR} function, to convert files on your local machine.
}
\value{GeoJSON file path, as string.}
\source{The code for the conversion of external data files is taken from the \code{togeojson} function of the \code{rgbif} package. Package import would have unreasonably increased the dependencies of \code{leafletR}.}
\author{Christian Graul}
\seealso{\code{\link{leaflet}}}
\examples{
\dontrun{
# convert data frame
data(quakes)
toGeoJSON(data=quakes, name="quakes", dest=tempdir(), lat.lon=c(1,2))

# convert data frame - minimal call
# storing output file path in variable
data(quakes)
path <- toGeoJSON(data=quakes)

# preserve existing files from overwriting
toGeoJSON(data=quakes, overwrite=FALSE)

# convert Spatial objects
library(sp)
data(meuse)
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")
toGeoJSON(data=meuse, dest=tempdir()) # rgdal package required

crd <- coordinates(meuse)
msl <- SpatialLines(list(Lines(list(Line(crd)), "line1")), 
  proj4string=CRS("+init=epsg:28992"))
toGeoJSON(data=msl, dest=tempdir()) # rgdal package required

data(meuse.riv)
msp <- SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)), 
  "meuse.riv")), proj4string=CRS("+init=epsg:28992"))
toGeoJSON(data=msp, dest=tempdir()) # rgdal package required

# convert a shapefile (in zipped archive)
# (httr package required)
toGeoJSON(data=system.file(package="leafletR", "files", "lynx.zip"), 
  name="lynx_telemetry", dest=tempdir())

# convert a KML/KMZ file
# using name of data file and saving to working directory
# (httr package required)
toGeoJSON(system.file(package="leafletR", "files", "peak_sk.kmz"))
}
}
\keyword{methods}
