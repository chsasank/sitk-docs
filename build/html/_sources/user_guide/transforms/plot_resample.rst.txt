

.. _sphx_glr_user_guide_transforms_plot_resample.py:


Transforms and Resampling
*************************

This tutorial explains how to apply transforms to images.

SimpleITK provides you with variety of transforms like Translation,
Affine (which includes rotations, shear, scaling)

It is important to keep in mind that these transforms are applied on the 
points in the physical space, not the image cordinates itself. 

.. contents:: On this Page
    :local:
    :backlinks: none




.. code-block:: python


    import SimpleITK as sitk
    import numpy as np
    from myshow import myshow







Creating and Manipulating Transforms
====================================
A number of different spatial transforms are available in SimpleITK.

Identity Transform
------------------
The simplest is the Identity Transform.
This transform simply returns input points unaltered.




.. code-block:: python



    dimension = 2

    print('*Identity Transform*')
    identity = sitk.Transform(dimension, sitk.sitkIdentity)
    print('Dimension: {}'.format(identity.GetDimension()))

    # Points are always defined in physical space
    point = (1.0, 1.0)


    def transform_point(transform, point):
        transformed_point = transform.TransformPoint(point)
        print('Point {} is transformed to {}'.format(point, transformed_point))

    transform_point(identity, point)





.. rst-class:: sphx-glr-script-out

 Out::

    *Identity Transform*
    Dimension: 2
    Point (1.0, 1.0) is transformed to (1.0, 1.0)


Transform are defined by two sets of parameters, the ``Parameters`` and
``FixedParameters``.  ``FixedParameters`` are not changed during the
optimization process when performing registration.

Translation Transform
---------------------
This transform simply translates input points by a offest.
For the TranslationTransform, the Parameters are the values of this translation
Offset.



.. code-block:: python


    print('*Translation Transform*')
    translation = sitk.TranslationTransform(dimension)

    print('Parameters: {}'.format(translation.GetParameters()))
    print('Offset:     {}'.format(translation.GetOffset()))
    print('FixedParameters: {}'.format(translation.GetFixedParameters()))
    transform_point(translation, point)

    print('')
    translation.SetParameters((3.1, 4.4))
    print('Parameters: {}'.format(translation.GetParameters()))
    transform_point(translation, point)





.. rst-class:: sphx-glr-script-out

 Out::

    *Translation Transform*
    Parameters: (0.0, 0.0)
    Offset:     (0.0, 0.0)
    FixedParameters: ()
    Point (1.0, 1.0) is transformed to (1.0, 1.0)

    Parameters: (3.1, 4.4)
    Point (1.0, 1.0) is transformed to (4.1, 5.4)


Affine Transform
----------------
The affine transform is capable of representing translations, rotations,
shearing, and scaling.

Affine transformation can be described with the following equation:

.. math::

    x' = A.(x-c) + t

where x is the input cordinate vector and x' is the output cordinate vector,
A is the affine matrix, t is the translation and c is the centre of
the affine transform.
By default, A = I and C = 0



.. code-block:: python


    print('*Affine Transform*')
    affine = sitk.AffineTransform(dimension)

    print('Parameters: {}'.format(affine.GetParameters()))
    print('FixedParameters: {}'.format(affine.GetFixedParameters()))
    transform_point(affine, point)

    print('')
    affine.SetTranslation((3.1, 4.4))
    print('Parameters: {}'.format(affine.GetParameters()))
    transform_point(affine, point)





.. rst-class:: sphx-glr-script-out

 Out::

    *Affine Transform*
    Parameters: (1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
    FixedParameters: (0.0, 0.0)
    Point (1.0, 1.0) is transformed to (1.0, 1.0)

    Parameters: (1.0, 0.0, 0.0, 1.0, 3.1, 4.4)
    Point (1.0, 1.0) is transformed to (4.1, 5.4)


A number of other transforms exist to represent non-affine deformations,
well-behaved rotation in 3D, etc. See the :doc:`Next guide` for more
information.

Applying Transforms to Images
=============================
Let's create a grid image to illustrate our transforms.



.. code-block:: python


    grid = sitk.GridSource(outputPixelType=sitk.sitkUInt16,
                           size=(250, 250),
                           sigma=(0.5, 0.5),
                           gridSpacing=(5.0, 5.0),
                           gridOffset=(0.0, 0.0),
                           spacing=(0.2, 0.2))

    myshow(grid, 'Grid Input')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_001.png
    :align: center




To apply the transform, a resampling operation is required.

.. note::

  Resample applies transform to phyiscal space, not voxel cordinates directly.
  Once phyiscal space is transformed, you will need to specify how you view
  this space by setting output origin, spacing and direction. Alternatively,
  you can specify a reference image so that output origin, spacing and
  direction are set to that of the reference image.

In the following ``resample`` function, output image Origin, Spacing, Size,
Direction are taken from the reference



.. code-block:: python



    def resample(image, transform):
        reference_image = image
        interpolator = sitk.sitkCosineWindowedSinc
        default_value = 100.0
        return sitk.Resample(image, reference_image, transform,
                             interpolator, default_value)







Let's apply translation to image



.. code-block:: python


    translation = sitk.TranslationTransform(2)
    translation.SetOffset((3.1, 4.6))
    transform_point(translation, point)
    resampled = resample(grid, translation)
    myshow(resampled, 'Resampled Translation')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_002.png
    :align: center


.. rst-class:: sphx-glr-script-out

 Out::

    Point (1.0, 1.0) is transformed to (4.1, 5.6)


What happened?  The translation is positive in both directions.  Why does the
output image move down and to the left?

.. note::

  It important to keep in mind that a transform in a resampling operation
  defines *the transform from the output space to the input space*.



.. code-block:: python


    inv_translation = translation.GetInverse()
    transform_point(inv_translation, point)
    resampled = resample(grid, inv_translation)
    myshow(resampled, 'Inverse Resampled')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_003.png
    :align: center


.. rst-class:: sphx-glr-script-out

 Out::

    Point (1.0, 1.0) is transformed to (-2.1, -3.5999999999999996)


An affine (line preserving) transformation, can perform translation, scaling,
rotation and shearing:
Translation
-----------



.. code-block:: python



    x_translation, y_translation = (3.1, 4.6)

    affine = sitk.AffineTransform(2)
    affine.SetTranslation((x_translation, y_translation))
    resampled = resample(grid, affine)
    myshow(resampled, 'Translated')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_004.png
    :align: center




Scaling
-------



.. code-block:: python

    x_scale, y_scale = 3.0, 0.7

    affine = sitk.AffineTransform(2)
    affine.Scale((x_scale, y_scale))
    resampled = resample(grid, affine)
    myshow(resampled, 'Scaled')





.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_005.png
    :align: center




Rotation
--------
We can either use ``AffineTransform::Rotate`` or directly set rotation matrix.
Let's take the first route.



.. code-block:: python


    degrees = 20

    affine = sitk.AffineTransform(2)
    radians = np.pi * degrees / 180.
    affine.Rotate(axis1=0, axis2=1, angle=radians)
    resampled = resample(grid, affine)
    myshow(resampled, 'Rotated')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_006.png
    :align: center




Shearing
--------
This time, let's directly set the matrix.



.. code-block:: python


    x_shear, y_shear = 0.3, 0.1

    matrix = np.eye(2)
    matrix[0, 1] = -x_shear
    matrix[1, 0] = -y_shear
    print(matrix)

    affine.SetMatrix(matrix.ravel())
    resampled = resample(grid, affine)
    myshow(resampled, 'Sheared')





.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_007.png
    :align: center


.. rst-class:: sphx-glr-script-out

 Out::

    [[ 1.  -0.3]
     [-0.1  1. ]]


Composite Transform
===================
It is possible to compose multiple transform together into a single transform 
object. With a composite transform, multiple resampling operations are 
prevented, so interpolation errors are not accumulated. For example, an 
affine transformation that consists of a translation and rotation:



.. code-block:: python


    translate = (8.0, 16.0)
    rotate = 20.0

    affine = sitk.AffineTransform(2)
    affine.SetTranslation(translate)
    affine.Rotate(axis1=0, axis2=1, angle=np.pi / 180 * rotate)

    resampled = resample(grid, affine)
    myshow(resampled, 'Single Transform')




.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_008.png
    :align: center




can also be represented with two Transform objects applied in sequence with 
a Composite Transform,



.. code-block:: python


    composite = sitk.Transform(2, sitk.sitkComposite)

    translation = sitk.TranslationTransform(2)
    translation.SetOffset(translate)
    composite.AddTransform(translation)

    affine = sitk.AffineTransform(2)
    affine.Rotate(axis1=0, axis2=1, angle=np.pi / 180 * rotate)
    composite.AddTransform(affine)

    resampled = resample(grid, composite)
    myshow(resampled, 'Two Transforms')



.. image:: /user_guide/transforms/images/sphx_glr_plot_resample_009.png
    :align: center




**Total running time of the script:** ( 0 minutes  0.870 seconds)



.. container:: sphx-glr-footer


  .. container:: sphx-glr-download

     :download:`Download Python source code: plot_resample.py <plot_resample.py>`



  .. container:: sphx-glr-download

     :download:`Download Jupyter notebook: plot_resample.ipynb <plot_resample.ipynb>`

.. rst-class:: sphx-glr-signature

    `Generated by Sphinx-Gallery <http://sphinx-gallery.readthedocs.io>`_
