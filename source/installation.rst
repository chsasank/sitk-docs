Installing SimpleITK
********************

Typically, you don't need to build SimpleITK to use it. 
You can simply download the binaries and get started right away!

Currently, Python binaries are available on Windows, Linux and Mac OS X. C# and Java binaries are available for Windows. We are also working towards supporting R packaging.

Python
======
`Virtual environments <http://docs.python-guide.org/en/latest/dev/virtualenvs/>`_ are highly recommended. They allow you to elegantly deal with package compatibility issues.

Standard Python installation
-----------------------------
From the shell, execute::
	
	pip install simpleitk

Conda-based distributions (Anaconda, Miniconda)
-----------------------------------------------
From the shell/command prompt, execute::
	
	conda install -c https://conda.anaconda.org/simpleitk SimpleITK

Beta and release candidate packages are also available on Anaconda cloud under the dev label::
	
	conda install -c https://conda.anaconda.org/simpleitk/label/dev SimpleITK


C Sharp (C#)
============
Binaries for select C# platform can be found on `SimpleITK's SourceForge page <https://sourceforge.net/projects/simpleitk/files/SimpleITK/0.10.0/CSharp/>`_. 
Installing the library should only involve importing the unzipped files into you C# environment. 

The files have the following naming convention::

	SimpleITK-version-CSharp-buildplatform-targetplatform.zip

Following files are currently available::
	
	SimpleITK-0.10.0-CSharp-win32-x86.zip
	SimpleITK-0.10.0-CSharp-win64-x64.zip

A guide describing how to set up a C# Visual Studio project with SimpleITK can be found :doc:`here <building/csharp>`. 
For platforms other than Windows, you might have to build manually as described in :doc:`building/unix`.

Java
====
Binaries for select Java platforms can be found on `SimpleITK's SourceForge page <https://sourceforge.net/projects/simpleitk/files/SimpleITK/0.10.0/Java/>`_. 

Following files are currently available::
	
	SimpleITK-0.10.0-Java-win64.zip	
	SimpleITK-0.10.0-Java-win32.zip	

More instructions are available at :doc:`building/java`

For platforms other than Windows, you might have to build manually as described in :doc:`building/unix`.