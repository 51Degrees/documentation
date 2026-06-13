/**
 * @file
 * examples.js
 *
 * Shared client-side behaviour for the 51Degrees SDK web examples
 * ("pattern-library-examples"). Framework-free; exposes a single global
 * `fodExamples`. Distributed alongside examples-main.css and consumed by the
 * device-detection-* and ip-intelligence-* "-examples" repos.
 *
 *   fodExamples.bindDeviceCallback(options)  device-detection: render the
 *       client-side refined results once 51Degrees.core.js fires `fod.complete`.
 *   fodExamples.initLocationMap(options)     ip-intelligence: draw a Leaflet
 *       map for a WKT polygon and/or a lat/long coordinate.
 */
(function (global) {
  'use strict';

  var fodExamples = {};

  // ---- device detection: client-side callback results --------------------

  // Subscribe to the `fod.complete` event raised by 51Degrees.core.js and
  // append a results table built from the refined flow data.
  fodExamples.bindDeviceCallback = function (options) {
    options = options || {};
    if (typeof global.fod === 'undefined' || !global.fod.complete) {
      return;
    }
    var targetId = options.targetId || 'content';
    var buildFields = options.fields || defaultDeviceFields;
    global.fod.complete(function (data) {
      renderTable(targetId, buildFields(data));
    });
  };

  function defaultDeviceFields(data) {
    var device = (data && data.device) || {};
    var hardwareName = typeof device.hardwarename === 'undefined'
      ? 'Unknown'
      : [].concat(device.hardwarename).join(', ');
    return [
      ['Hardware Name:', hardwareName],
      ['Platform:', join(device.platformname, device.platformversion)],
      ['Browser:', join(device.browsername, device.browserversion)],
      ['Screen width (pixels):', device.screenpixelswidth],
      ['Screen height (pixels):', device.screenpixelsheight]
    ];
  }

  function join(a, b) {
    return [a, b].filter(function (v) { return v != null && v !== ''; }).join(' ');
  }

  function renderTable(targetId, fieldValues) {
    var target = document.getElementById(targetId);
    if (!target) {
      return;
    }
    var table = document.createElement('table');
    table.className = 'c-eg-table';

    var head = document.createElement('tr');
    head.className = 'c-eg-table__row c-eg-table__head';
    addCell(head, 'th', 'Key', false);
    addCell(head, 'th', 'Value', false);
    table.appendChild(head);

    fieldValues.forEach(function (entry) {
      var row = document.createElement('tr');
      row.className = 'c-eg-table__row c-eg-table__row--used';
      addCell(row, 'td', entry[0], true);
      addCell(row, 'td', entry[1], false);
      table.appendChild(row);
    });

    target.appendChild(table);
  }

  function addCell(row, tag, text, isKey) {
    var cell = document.createElement(tag);
    cell.className = 'c-eg-table__cell' + (isKey ? ' c-eg-table__cell--key' : '');
    var node = document.createTextNode(text == null ? '' : text);
    if (isKey) {
      var strong = document.createElement('strong');
      strong.appendChild(node);
      node = strong;
    }
    cell.appendChild(node);
    row.appendChild(cell);
  }

  // ---- ip intelligence: location map -------------------------------------

  // Draw a Leaflet map for the supplied WKT polygon (options.areasWkt) and/or
  // coordinate (options.latitude/longitude). Requires Leaflet (global L) and,
  // for polygons, wellknown to be loaded by the host page.
  fodExamples.initLocationMap = function (options) {
    options = options || {};
    var L = global.L;
    if (!L) {
      return;
    }

    var sectionId = options.sectionId || 'map-section';
    var canvasId = options.canvasId || 'map';
    var areasWkt = options.areasWkt || '';
    var latitude = options.latitude;
    var longitude = options.longitude;
    var labels = options.labels || { ipLocation: 'IP Location', lat: 'Lat', lng: 'Lng' };
    var tileUrl = options.tileUrl
      || 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
    var tileOptions = {
      attribution: '© OpenStreetMap contributors © CARTO',
      subdomains: 'abcd',
      maxZoom: 19
    };

    if (isValid(areasWkt) && areasWkt !== 'POLYGON EMPTY' && global.wellknown) {
      setSection(sectionId, true);
      var map = L.map(canvasId);
      L.tileLayer(tileUrl, tileOptions).addTo(map);
      try {
        var geoJson = global.wellknown.parse(areasWkt);
        if (geoJson) {
          var polygon = L.geoJSON(geoJson, {
            style: {
              color: '#CC2B27', weight: 2, opacity: 0.8,
              fillColor: '#CC2B27', fillOpacity: 0.2
            }
          }).addTo(map);
          map.fitBounds(polygon.getBounds());
          addMarker(L, map, latitude, longitude, labels);
        }
      } catch (e) {
        console.error('Error parsing polygon:', e);
        setSection(sectionId, false);
      }
    } else if (isValid(latitude) && isValid(longitude)) {
      var lat = parseFloat(latitude);
      var lng = parseFloat(longitude);
      if (!isNaN(lat) && !isNaN(lng)) {
        setSection(sectionId, true);
        var pointMap = L.map(canvasId).setView([lat, lng], 10);
        L.tileLayer(tileUrl, tileOptions).addTo(pointMap);
        addMarker(L, pointMap, latitude, longitude, labels);
      }
    }
  };

  function addMarker(L, map, latitude, longitude, labels) {
    if (!isValid(latitude) || !isValid(longitude)) {
      return;
    }
    var lat = parseFloat(latitude);
    var lng = parseFloat(longitude);
    if (isNaN(lat) || isNaN(lng)) {
      return;
    }
    L.marker([lat, lng])
      .addTo(map)
      .bindPopup(labels.ipLocation + '<br>' + labels.lat + ': ' + lat + '<br>' + labels.lng + ': ' + lng)
      .openPopup();
  }

  function setSection(sectionId, visible) {
    var section = document.getElementById(sectionId);
    if (section) {
      section.style.display = visible ? 'block' : 'none';
    }
  }

  function isValid(value) {
    return value && String(value).indexOf('Unknown') === -1 && value !== '0' && value !== '';
  }

  global.fodExamples = fodExamples;
})(window);
