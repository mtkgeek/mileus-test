String fetchRouteUrl(
        String orLat, String orLong, String destLat, String destLong) =>
    "https://router.project-osrm.org/route/v1/driving/$orLong,$orLat;$destLong,$destLat?overview=full&geometries=geojson&annotations=duration";
