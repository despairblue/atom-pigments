RegionRenderer = require './region-renderer'

module.exports =
class BackgroundRenderer extends RegionRenderer
  includeTextInRegion: true
  render: (colorMarker) ->
    range = colorMarker.marker.getScreenRange()
    return [] if range.isEmpty()

    color = colorMarker.color.toCSS()

    l = colorMarker.color.luma

    colorText = if l > 0.43 then 'black' else 'white'

    rowSpan = range.end.row - range.start.row
    regions = []
    if rowSpan is 0
      regions.push @createRegion(range.start, range.end, colorMarker)
    else
      regions.push @createRegion(range.start, {row: range.start.row, column: Infinity}, colorMarker)
      if rowSpan > 1
        for row in [range.start.row + 1...range.end.row]
          regions.push @createRegion({row, column: 0}, {row, column: Infinity}, colorMarker)

      regions.push @createRegion({ row: range.end.row, column: 0 }, range.end, colorMarker)

    @styleRegion(region, color, colorText) for region in regions
    {regions}

  styleRegion: (region, color, textColor) ->
    region.classList.add('background')

    region.style.backgroundColor = color
    region.style.color = textColor