# Modified ER: separate paddings in get_... , separate stride, I/O
# https://github.com/jerryjingli/cs231_assignment/blob/master/winter1516_assignment2/cs231n/im2col.py
#
import numpy as np
import array,struct
import sys

# padding is top,left,bottom,right
def get_im2col_indices(x_shape, field_height, field_width, padding=(1,1,1,1), stridex=1,stridey=1,verbose=False):
  # First figure out what the size of the output should be
  N, C, H, W = x_shape
  assert (H + padding[0]+padding[2] - field_height) % stridey == 0
  assert (W + padding[1]+padding[3] - field_width) % stridex == 0
  out_height = (H + padding[0]+padding[2] - field_height) / stridey + 1
  out_width = (W + padding[1]+padding[3] - field_width) / stridex+ 1
  if verbose:
    print "get_im2col_indices",x_shape,field_height,field_width,padding,stridex,stridey,"out",out_height,out_width

  i0 = np.repeat(np.arange(field_height), field_width)
  i0 = np.tile(i0, C)
  i1 = stridey * np.repeat(np.arange(out_height), out_width)
  j0 = np.tile(np.arange(field_width), field_height * C)
  j1 = stridex * np.tile(np.arange(out_width), out_height)
  i = i0.reshape(-1, 1) + i1.reshape(1, -1)
  j = j0.reshape(-1, 1) + j1.reshape(1, -1)

  k = np.repeat(np.arange(C), field_height * field_width).reshape(-1, 1)

  return (k, i, j,out_height,out_width)


def im2col_indices(x, field_height, field_width, padding=1, stridex=1,stridey=1,verbose=False):
  """ An implementation of im2col based on some fancy indexing """
  # Zero-pad the input
  p = padding
  x_padded = np.pad(x, ((0, 0), (0, 0), (p, p), (p, p)), mode='constant')

  k, i, j, out_height, out_width = get_im2col_indices(x.shape, field_height, field_width, padding,
                               stridex,stridey,verbose)

  cols = x_padded[:, k, i, j]
  print "int cols is",cols.shape
  C = x.shape[1]
  cols = cols.transpose(1, 2, 0).reshape(field_height * field_width * C, -1)
  return cols


def col2im_indices(cols, x_shape, field_height=3, field_width=3, padding=1,
                   stridex=1,stridey=1):
  """ An implementation of col2im based on fancy indexing and np.add.at """
  N, C, H, W = x_shape
  H_padded, W_padded = H + 2 * padding, W + 2 * padding
  x_padded = np.zeros((N, C, H_padded, W_padded), dtype=cols.dtype)
  k, i, j,out_height,out_width = get_im2col_indices(x_shape, field_height, field_width, padding,
                               stridex,stridey)
  cols_reshaped = cols.reshape(C * field_height * field_width, -1, N)
  cols_reshaped = cols_reshaped.transpose(2, 0, 1)
  np.add.at(x_padded, (slice(None), k, i, j), cols_reshaped)
  if padding == 0:
    return x_padded
  return x_padded[:, :, padding:-padding, padding:-padding]

def writeint(x,of):
  of.write(struct.pack("i",x))

def writenp(x,of):
  #l = x.ravel().astype(np.int32).tolist()
  #writeint(len(l),of)
  #a = array.array("L")
  #a.fromlist(l)
  #a.tofile(of)
  of.write(struct.pack("ii",x.shape[0],x.shape[1]))
  x.astype(np.int32).tofile(of)

def main():
  if len(sys.argv) != 1+1+8+3:
    print len(sys.argv)
    print "outfile,C,rows,cols,field_height,field_width,paddingT,paddingL,paddingB,paddingR,stridex,stridey"
    print "outfile is binary of uint32 with: outheight,outwidth,k,i,j"
    print "where k,i,j are rows,cols,data as in numpy"
    return
  outfile = sys.argv[1]
  C,rows,cols,field_height,field_width,padding1,padding2,padding3,padding4,stridex,stridey = [int(y) for y in sys.argv[2:]]

  if outfile == "!":
    r = im2col_indices(np.ones((7,C,rows,cols)),field_height,field_width,(padding1,padding2,padding3,padding4),stridex,stridey,verbose=True)
  else:
    try:
      k,i,j,out_height,out_width = get_im2col_indices((1,C,rows,cols),field_height,field_width,(padding1,padding2,padding3,padding4),stridex,stridey)
    except:
      print sys.exc_info()
      x = open(outfile,"w")
      x.close()
      return
    x = open(outfile,"w")
    writeint(out_height,x)
    writeint(out_width,x)
    writenp(k,x)
    writenp(i,x)
    writenp(j,x)
    x.close()

if __name__ == '__main__':
  main()