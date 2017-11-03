import sys
import re
def doline(line,vars,las):
	k = line.find("+=")
	if k >= 0 and line[0] != " " and line[0] != "\t":
		name,value = line.split("=",1)
		name =name.strip()
		value = value.strip()
		if name[0] != "@":
			print name,value
			#las.append((name,value,"+="))
			#las.append(name)
			value = value.replace("$(notdir $(PRODUCT))","$(PRODUCT_NAME)")
			vars[name]= vars.get(name,"") + value
		return
	k = line.find("=")
	if k >= 0 and line[0] != " " and line[0] != "\t":
		name,value = line.split("=",1)
		name =name.strip()
		value = value.strip()
		if name[0] != "@":
			print name,value
			value = value.replace("$(notdir $(PRODUCT))","$(PRODUCT_NAME)")
			las.append(name)
			vars[name]= value

def main():
	vars = {}
	remove = set(["ALL_OBJS","MAIN_OBJ","OBJS","XCODE_SDK_VER","XCODE_SDK","XCODE_DEVEL_DIR","XCODE_SDK_ROOT"])
	las = []
	preline = ""
	for line in open(sys.argv[1],"r"):
		line = line.strip()
		if line == "" or line[0] == "#":
			continue
		if line[-1] == "\\":
			preline = preline + line[-1]
			continue
		else:
			if preline != "":
				doline(preline,vars,las)
				preline = ""
			doline(line,vars,las)
	if preline != "":
		doline(preline,vars,las)
		preline = ""
	for k in las:
		v = vars[k]
		m = re.findall(r"\$\(([^)]+)\)",v)
		print k,m
		v = re.sub(r"\$\(([^)]+)\)","${\\1}",v)
		vars[k] = v
	# fix $(MATLAB_ROOT) 
	# fix $(START_DIR)
	o = open("CMakeLists.txt","w")
	o.write("project(%s)\n" % vars["PRODUCT_NAME"])
	o.write("set(XCODE_SDK_ROOT /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/)\n")
	for k in las:
		if k not in remove:	
			o.write("set(%s %s)\n" % (k,vars[k]))
	what = "executable" if vars["PRODUCT_TYPE"] == "\"executable\"" else "library"
	what = "executable"
	o.write("make_policy(SET CMP0069 NEW)\n")
	o.write("#set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)\n")
	o.write("add_definitions(-march=native -O3)\n")
	o.write("add_definitions(${DEFINES})\n")
	includes = [y.strip() for y in vars["INCLUDES_BUILDINFO"].split("-I") if len(y.strip()) != ""]
	o.write("include_directories(%s)\n" % " ".join(includes))
	o.write("add_definitions(-pg)\n")
	o.write("SET( CMAKE_EXE_LINKER_FLAGS  ${CMAKE_EXE_LINKER_FLAGS} -pg)\n")
	o.write("add_%s(%s ${MAIN_SRC} ${SRCS})\n" % (what,vars["PRODUCT_NAME"]))
if __name__ == '__main__':
	main()