Image Basics
************

:cpp:class:`Image <itk::simple::Image>` class is basic container for image data in SimpleITK. 
It can hold 2 or 3 dimensional images and pixel can be either be a scalar or a vector. 
A RGB image for example, is a 2 dimensional image with 3 component vector pixel.

.. contents:: Contents
    :local:
    :backlinks: none

Construction
============
There are a variety of ways to create an image. 
All images' initial value is well defined as zero

.. code-block:: cpp

    Image(width, height, pixelID)
    Image(width, height, depth, pixelID)
    Image(sizeVector, pixelID)
    Image(sizeVector, pixelID, numberOfComponents)

For example, in python you can create a RGB image of size 128x64 as

.. code-block:: python

    >>> import SimpleITK as sitk
    >>> image_RGB = sitk.Image([128,64], sitk.sitkVectorUInt8, 3)


Pixel Types
===========
The pixel type is represented as an enumerated type ``PixelIDValueEnum`` . The following is a table of the enumerated list.

======================      ==========================================
EnumValue                   Description
======================      ==========================================
``sitkUInt8``               Unsigned 8 bit integer
``sitkInt8``                Signed 8 bit integer
``sitkUInt16``              Unsigned 16 bit integer
``sitkInt16``               Signed 16 bit integer
``sitkUInt32``              Unsigned 32 bit integer
``sitkInt32``               Signed 32 bit integer
``sitkUInt64``              Unsigned 64 bit integer
``sitkInt64``               Signed 64 bit integer
``sitkFloat32``             32 bit float
``sitkFloat64``             64 bit float
``sitkComplexFloat32``      complex number of 32 bit float
``sitkComplexFloat64``      complex number of 64 bit float
``sitkVectorUInt8``         Multi-component of unsigned 8 bit integer
``sitkVectorInt8``          Multi-component of signed 8 bit integer
``sitkVectorUInt16``        Multi-component of unsigned 16 bit integer
``sitkVectorInt16``         Multi-component of signed 16 bit integer
``sitkVectorUInt32``        Multi-component of unsigned 32 bit integer
``sitkVectorInt32``         Multi-component of signed 32 bit integer
``sitkVectorUInt64``        Multi-component of unsigned 64 bit integer
``sitkVectorInt64``         Multi-component of signed 64 bit integer
``sitkVectorFloat32``       Multi-component of 32 bit float
``sitkVectorFloat64``       Multi-component of 64 bit float
``sitkLabelUInt8``          RLE label of unsigned 8 bit integers
``sitkLabelUInt16``         RLE label of unsigned 16 bit integers
``sitkLabelUInt32``         RLE label of unsigned 32 bit integers
``sitkLabelUInt64``         RLE label of unsigned 64 bit integers
======================      ==========================================

There is also ``sitkUnknown``, which is used for undefined or erroneous pixel ID's. It has a value of ``-1``.
The 64-bit integer types are not available on all distributions. When not available the value is ``sitkUnknown``.

You can get the type of pixel using 
:cpp:func:`Image::GetPixelID() <itk::simple::Image::GetPixelID>`
and its string representation using 
:cpp:func:`Image::GetPixelIDTypeAsString() <itk::simple::Image::GetPixelIDTypeAsString>`

Images and Physical Space
=========================

The unique feature of SimpleITK (derived from ITK) as a toolkit for image manipulation and analysis is that it views *images as physical objects occupying a bounded region in physical space*. 
In addition images can have different spacing between pixels along each axis, and the axes are not necessarily orthogonal. The following figure illustrates these concepts.

.. image:: images/ImageOriginAndSpacing.png

Each :cpp:class:`Image <itk::simple::Image>` has following properties:

**Pixel type**
    Type of pixel/voxel. Refer to table above. In case of a vector image, number of components per pixel can be greater than 1. This is fixed on creation. 

    Can get pixel type through :cpp:func:`Image::GetPixelID() <itk::simple::Image::GetPixelID>`.
    Number of components per pixel can be found by :cpp:func:`Image::GetNumberOfComponentsPerPixel()<itk::simple::Image::GetNumberOfComponentsPerPixel>`

**Size** 
    Number of pixels/voxels in each dimension. This quantity implicitly defines the image dimension.
    This is also fixed on creation. 

    Size of the image can be found by :cpp:func:`Image::GetSize() <itk::simple::Image::GetSize>` and dimension by :cpp:func:`Image::GetDimension() <itk::simple::Image::GetDimension>`

**Origin**
    Coordinates of the pixel/voxel with index (0,0,0) in physical units (i.e. mm). Default is zero i.e. origin of physical space.

    :cpp:func:`Image::GetOrigin() <itk::simple::Image::GetOrigin>` and 
    :cpp:func:`Image::SetOrigin() <itk::simple::Image::SetOrigin>` can be used to get and set origin respectively.

**Spacing**
    Distance between adjacent pixels/voxels in each dimension given in physical units.
    Default is one i.e. (1 mm, 1 mm, 1 mm). 

    :cpp:func:`Image::GetSpacing() <itk::simple::Image::GetSpacing>` and 
    :cpp:func:`Image::SetSpacing() <itk::simple::Image::SetSpacing>` can be used to get and set spacing respectively.

**Direction Matrix**
    Mapping/rotation between direction of the pixel/voxel axes and physical directions. Default is identity matrix. The matrix is passed as a 1D array in row-major form.

    :cpp:func:`Image::GetDirection() <itk::simple::Image::GetDirection>` and 
    :cpp:func:`Image::SetDirection() <itk::simple::Image::SetDirection>` can be used to get and set direction matrix respectively.

.. note ::
    All the transformations like rotation or affine transform are done on the underlying physical space. You can think of image of a view of this physical space.

Transform voxels to physical space
----------------------------------

Following equation can be used to convert voxel coordinates/indices to physical coordinates:

.. math::

    x = D.S.v + o

where x is coordinate of the voxel in physical space, v is voxel index, o is origin, D is direction matrix and S is *diag* (spacing).

These functions can be directly used to transform between voxel and physical space: 

* :cpp:func:`Image::TransformContinuousIndexToPhysicalPoint() <itk::simple::Image::TransformContinuousIndexToPhysicalPoint>`
* :cpp:func:`Image::TransformIndexToPhysicalPoint() <itk::simple::Image::TransformIndexToPhysicalPoint>`
* :cpp:func:`Image::TransformPhysicalPointToContinuousIndex() <itk::simple::Image::TransformPhysicalPointToContinuousIndex>`
* :cpp:func:`Image::TransformPhysicalPointToIndex() <itk::simple::Image::TransformPhysicalPointToIndex>`

Accessing Pixels
================

You can get the pixel values using one of 
:cpp:func:`Image::GetPixelAsInt8() <itk::simple::Image::GetPixelAsInt8>`, 
:cpp:func:`Image::GetPixelAsUInt32()  <itk::simple::Image::GetPixelAsUInt32>`, 
:cpp:func:`Image::GetPixelAsFloat()  <itk::simple::Image::GetPixelAsFloat>`
:cpp:func:`Image::GetPixelAsDouble()  <itk::simple::Image::GetPixelAsDouble>` etc.

Similarly, you can set the pixel values using 
:cpp:func:`Image::SetPixelAsInt8() <itk::simple::Image::SetPixelAsInt8>`, 
:cpp:func:`Image::SetPixelAsUInt32()  <itk::simple::Image::SetPixelAsUInt32>`, 
:cpp:func:`Image::SetPixelAsFloat()  <itk::simple::Image::SetPixelAsFloat>`
:cpp:func:`Image::SetPixelAsDouble()  <itk::simple::Image::SetPixelAsDouble>` etc.

In dynamic type languages like python and lua, ``GetPixel`` and ``SetPixel`` are available.
In python, you can also use pythonic indexing to get and set pixel values.


For example::
    
    >>> import SimpleITK as sitk
    >>> image = sitk.ReadImage('T1_MRI.nii.gz')
    >>> x, y, z = 10, 15, 20
    >>> # These two mean the same
    >>> image.GetPixel((x, y, z))
    26.7
    >>> img[x, y, z]
    26.7
    >>> # These two mean the same
    >>> image.SetPixel((x, y, z), 1.2)
    >>> image[x, y, z] = 1.2

Arrays/Tensors
--------------

If you have `numpy <http://www.numpy.org>`_ library installed in python, you can convert images to arrays and vice versa using ``GetArrayFromImage()`` and ``GetImageFromArray()``.
Similarly, if you have `torch <http://torch.ch>`_ installed, you can use ``GetTensorFromImage()`` and ``GetImageFromTensor()``.
Numpy and torch are numerical computational libraries for python and lua respectively.

.. note ::
    While converting from tensor/array to Image, remember to set the image's origin, spacing, and possibly direction cosine matrix. The default values may not match the physical dimensions of your image.

.. note ::

    Image access is in x,y,z order (image.GetPixel(x,y,z) or image[x,y,z]) with zero based indexing. Note that this is different from numpy or torch indexing which uses z, y, x order.

In numpy for example: ::

    >>> import SimpleITK as sitk
    >>> sitkimg = sitk.Image(10, 20, 30, sitk.sitkFloat32)
    >>> sitkimg[1, 2, 3] = 1.5
    >>> npimg = sitk.GetArrayFromImage(sitkimg)
    >>> print(sitkimg.GetSize())
    (10, 20, 30)
    >>> print(npimg.shape)
    (30, 20, 10)
    >>> print(npimg[1, 2, 3], npimg[3, 2, 1])
    0 1.5

In torch, indexing starts with 1:

.. code-block:: lua
    
    sitk = require 'SimpleITK'
    sitkimg = sitk.Image(10, 20, 30, sitk.sitkFloat32)
    sitkimg:SetPixel({1, 2, 3}, 1.5)
    thimg = sitk.GetTensorFromImage(sitkimg)

    sitksize = sitkimg:GetSize()
    thsize = thimg:size()
    print(sitksize[0], sitksize[1], sitksize[2]) -- prints 10 20 30
    print(thsize[1], thsize[2], thsize[3])       -- prints 30 20 10
    print(thimg[{2, 3, 4}], thimg[{3, 2, 1}],
                            thimg[{4, 3, 2}])    -- prints 0 0 1.5

Slicing
-------
:cpp:func:`Slice() <itk::simple::Slice>` can be used to slice the image and a dimension can be collapsed with :cpp:func:`Extract() <itk::simple::Extract>`. 
In python, you can use pythonic slicing without having to use these: ::
    
    >>> logo = sitk.ReadImage('SimpleITK.png')
    >>> # Brute force subsampling 
    >>> logo_subsampled = logo[::2,::2]
    >>> # Get the sub-image containing the word Simple
    >>> simple = logo[0:155,:]
    >>> # Get the sub-image containing the word Simple and flip it
    >>> simple_flipped = logo[155:0:-1,:]
    >>> # Save images
    >>> sitk.WriteImage(logo_subsampled, 'SimpleITK_subsampled.png')
    >>> sitk.WriteImage(simple, 'SimpleITK_simple.png')
    >>> sitk.WriteImage(simple_flipped, 'SimpleITK_simpleflipped.png')


.. image:: images/SimpleITK.png

.. image:: images/SimpleITK_subsampled.png
    :align: right

.. image:: images/SimpleITK_simple.png

.. image:: images/SimpleITK_simpleflipped.png
    :align: right


Image Operations
================
SimpleITK supports basic arithmetic operations between images, **taking into account their physical space**::
    
    >>> img1 = sitk.Image(24,24, sitk.sitkUInt8)
    >>> img2 = sitk.Image(img1.GetSize(), sitk.sitkUInt8)
    >>> img1[0, 0] = 10
    >>> img2[0, 0] = 30
    >>> img3 = img1 + img2
    >>> img4 = img1 + 72
    >>> print(img3[0, 0], img4[0, 0])
    40 82
    >>> img2.SetOrigin([3, 5])
    >>> # Following raises error as the images are not in the
    >>> # same physical space
    >>> img5 = img1 + img2 
    Traceback (most recent call last):
        ...
    RuntimeError: Exception thrown in SimpleITK Add: ../include/itkImageToImageFilter.hxx:24
    8:
    itk::ERROR: AddImageFilter(0x103cda880): Inputs do not occupy the same physical 
    space! 
    InputImage Origin: [0.0000000e+00, 0.0000000e+00], InputImage_1 Origin: [3.00000
    00e+00, 5.0000000e+00]
        Tolerance: 1.0000000e-06


Following are some of the pixel-wise operations that can be used with image, image pairs or image, scalar pairs:
    
* Addition ``+``
* Subtraction ``-``
* Multiplication ``*``
* Division ``/``
* Modulo ``%``
* Power ``**``

Lot more operations like sine, cosine, exponentation etc. are also available.