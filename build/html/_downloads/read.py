"""
How to read nii.gz Images
=========================

This is how you read 3d images in python.
"""
import SimpleITK as sitk
img = sitk.ReadImage('file.nii.gz')
sitk.WriteImage(img, 'file2.nii.gz')
