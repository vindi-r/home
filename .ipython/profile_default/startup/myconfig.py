#!/usr/bin/env python
# coding:utf-8 vi:et:ts=2

from io import BytesIO
from PIL import Image
import IPython.core.display


def displayPilImage( o_image ):
  """Render PIL image inside IPython"""

  oBytes = BytesIO()
  o_image.save( oBytes, format = 'png' )
  oData = oBytes.getvalue()
  oIpImage = IPython.core.display.Image(
    data = oData,
    format = 'png',
    embed = True )
  return oIpImage._repr_png_()


oFormatter = get_ipython().display_formatter.formatters[ 'image/png' ]
oFormatter.for_type( Image.Image, displayPilImage )

