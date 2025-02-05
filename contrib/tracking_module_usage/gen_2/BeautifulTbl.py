# -*- python -*-
from __future__ import print_function
import re

class BeautifulTbl(object):
  def __init__(self, **kwargs):
    self.__gap      = kwargs.get("gap",        2)
    self.__column   = kwargs.get("column",     0)
    self.__wrapped  = kwargs.get("wrapped",    False)
    self.__justify  = kwargs.get("justify",    False) or "".join(kwargs.get("justifyT",   []))
    self.__tbl      = self.__build_tbl(kwargs.get("tbl",None))

  def __build_tbl(self,tblIn):
    columnCnt = []
    tbl       = []
    justify   = self.__justify
    maxnc     = 0
    gap       = self.__gap

    for irow, row in enumerate(tblIn):
      for icol, v in enumerate(row):
        v = str(v)
        if (icol == maxnc):
          columnCnt.append(0)
          maxnc += 1
        columnCnt[icol] = max(len(v), columnCnt[icol])

    # build justifyT
    nc = len(justify)
    justifyT = []
    for icol in range(nc):
      justifyT.append((justify[icol].lower() == "r") and "r" or "l")

    for i in range(nc, maxnc):
      justifyT.append("l")

    for irow, row in enumerate(tblIn):
      b    = []
      numC = len(row)
      for icol, v in enumerate(row):
        v = str(v)
        if (numC == 1):
          b.append(v)
        else:
          nspaces = columnCnt[icol] - len(v)
          if (justifyT[icol] == "l"):
            b.append(v + " "*(nspaces+gap))
          else:
            b.append(" "*nspaces + v + " "*gap)
      tbl.append(b)
    self.__columnCnt = columnCnt
    self.__maxnc     = maxnc
    self.__justifyT  = justifyT
    return tbl

  def build_tbl(self):

    width      = 0
    column     = self.__column - 1
    gap        = self.__gap
    simple     = True
    columnCnt  = self.__columnCnt
    justifyT   = self.__justifyT

    if (self.__wrapped and self.__column > 0):
      for icol in range(len(columnCnt)-1):
        width += columnCnt[icol] + gap
      last = columnCnt[-1]
      simple = (width > column - 10) or (width + last < column)

    tbl = self.__tbl

    if (len(tbl) < 1):
      return ""

    a = []
    if (simple):
      for row in tbl:
        row[-1] = row[-1].rstrip()
        a.append("".join(row))
      return "\n".join(a)

    # If here then the last column must be wrapped. It removes any
    # trailing spaces.  Note that the last column is the only column
    # that is word wrapped.  Any short rows are copied straight
    # across.

    gap    = column - width
    fill   = " "*width

    maxnc  = self.__maxnc
    maxnc1 = maxnc - 1

    for irow, row in enumerate(tbl):
      aa  = []
      nc  = len(row)
      nc1 = min(nc, maxnc1)

      for i in range(nc1):
        aa.append(row[i])

      # Now word wrap last column
      aaa = []
      if (nc == maxnc):
        icnt = width
        s    = row[-1]
        iter_matches = re.finditer(r'\w+', s)
        for match in iter_matches:
          word = match.group(0)
          wlen = len(word)+1
          if   (word == ""):
            wlen = 0
          elif (icnt + wlen < column or wlen > gap ):
            aaa.append(word + " ")
          else:
            aaa[-1] = aaa[-1].rstrip()
            line   = "".join(aaa)
            if (justifyT[-1] == "r"):
                aa.append(" "*(gap - len(line)))
            aa.append(line)
            aa.append("\n")
            a.append("".join(aa))
            aaa = []
            aa  = []
            aa.append(fill)
            aaa.append(word + " ")
            icnt = width
          icnt += wlen
      aaa[-1] = aaa[-1].rstrip()
      line    = "".join(aaa)
      if (justifyT[-1] == "r"):
        aa.append(" "*(gap - len(line)))
      aa.append(line)
      aa.append("\n")
      a.append("".join(aa))
    return "".join(a)


def main():

  a = [
      ["a23456", "b23456789 123456789 123456", "c0_456789 c1_456789 c2_456789 c3_456789 c4_456789 c5_456 c6_4567"],
      ["A23",    "B23456789 12345",            "C0_456789 C1_456789 C2_456789 C3_45678"],
      ]

  b = [
      ["abc as", "d a alsdkjf lkjasdf alsdjf", "laskdjfasjkd alsdkj alksdj asdlkfj asdlk aalsdkjf pasd f"],
      ["def", "ghialksdflaksdf", "la laksjd alskd laksjd asdlkfj asdpsdf"],
      ]


  bt = BeautifulTbl(tbl=a,column=79, wrapped=True, justify = "rrr")
  s  = bt.build_tbl()
  print ("         1         2         3         4         5         6         7         8")
  print ("123456789 "*8)

  print (s)

if ( __name__ == '__main__'): main()




