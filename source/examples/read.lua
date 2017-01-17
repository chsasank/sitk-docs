--[[
How to read nii.gz images
=========================

This is how you read 3d images in lua.
--]]
sitk = require 'SimpleITK'
img = sitk.ReadImage('file.nii.gz')
sitk.WriteImage(img, 'file2.nii.gz')