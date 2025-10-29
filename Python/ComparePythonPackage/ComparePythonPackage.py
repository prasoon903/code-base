import pkgutil
import os

def list_submodules(package_name):
    """
    List submodules (libraries) within a Python package.
    """
    package = __import__(package_name)
    package_path = getattr(package, "__path__", [])
    submodules = []

    for _, name, is_pkg in pkgutil.iter_modules(package_path):
        if is_pkg:
            submodules.extend(list_submodules(package_name + "." + name))
        else:
            submodules.append(name)

    return submodules

def compare_packages(package1, package2):
    """
    Compare libraries available in two Python packages.
    """
    libs_package1 = set(list_submodules(package1))
    libs_package2 = set(list_submodules(package2))

    common_libs = libs_package1.intersection(libs_package2)
    unique_libs_package1 = libs_package1 - libs_package2
    unique_libs_package2 = libs_package2 - libs_package1

    return common_libs, unique_libs_package1, unique_libs_package2

os.chdir('E:\\Python\\BehaveBDD\\')

# Replace 'package1' and 'package2' with the names of the packages you want to compare
package1 = 'E:\\Python\\BehaveBDD\\Python310_v3\\'
package2 = 'E:\\Python\\BehaveBDD\\Python310\\'

common_libs, unique_libs_package1, unique_libs_package2 = compare_packages(package1, package2)

print("Common libraries:")
for lib in common_libs:
    print(lib)

print("\nLibraries unique to '{}' package:".format(package1))
for lib in unique_libs_package1:
    print(lib)

print("\nLibraries unique to '{}' package:".format(package2))
for lib in unique_libs_package2:
    print(lib)
