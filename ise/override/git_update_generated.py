#!/usr/local/bin/python
"""
	This script is to copy generated (unversioned) Eiffel file into generated folder.
	maintainer: Jocelyn (jfiat@eiffel.com)
"""

import sys;
import os;
import string
import re

def get_output (a_cmd):
#	sys.stderr.write ("Execute: %s\s \n" %(a_cmd))
	r = os.popen (a_cmd, 'r').read ()
	return r

def regexp_escape (a_string):
	r = a_string
	r = string.replace (r, '\\', '\\\\')
	r = string.replace (r, '/', '\\/')
	r = string.replace (r, '.', '\\.')
	return r

def makedirs(a_dir):
	if not os.path.exists (a_dir):
		os.makedirs (a_dir)

def nodes_in_folder (a_dir, a_pattern="^.*\.e$", rec=True):
	if len(a_pattern) > 0:
		p = re.compile (a_pattern)
	else:
		p = None

	nodes = os.listdir (a_dir)
	r = []
	for n in nodes:
		fn = os.path.join (a_dir, n)
		if os.path.isdir (fn) and rec:
			sr = nodes_in_folder (fn, a_pattern, rec)
			for i in sr:
				r.append ({'dir':i['dir'], 'file':i['file']})
		else:
			if p != None:
				result = p.search(n,0)
				if result:
					r.append ({'dir':a_dir, 'file':n})
			else:
				r.append ({'dir':a_dir, 'file':n})
	return r

def clean_folder (a_target):
	lst = nodes_in_folder (a_target, "^.*\.e$")
	nb = 0
	for i in lst:
		fn = os.path.join (i['dir'], i['file'])
#		print ("Clean: %s" % (fn))
		print "  - %s"% (fn)
		os.remove (fn)
		nb = nb + 1
	print ("*    cleaning completed - %d files removed -" % (nb))

def update_node (a_src, a_target, a_dir, a_name):
	import shutil

	#print "makedirs %s" % (os.path.join (a_target, a_dir))
	orig_fn = os.path.join (a_src, a_dir, a_name)
	target_fn = os.path.join (a_target, a_dir, a_name)
	if os.path.exists(orig_fn):
		makedirs (os.path.join (a_target, a_dir))
		#print "Copy [%s] to [%s]" % (orig_fn, target_fn)
		shutil.copy2 (orig_fn, target_fn)
		os.remove (orig_fn)
	#	copyfile (os.path.join (a_src, a_dir, a_name), os.path.join (a_target, a_name))
		print "  + %s"% (os.path.join (a_dir, a_name))
	else:
		print "  ? %s"% (os.path.join (a_dir, a_name))

def is_wanted_file(n):
	a_pattern=".*\.(ge|e|y|l)$"
	p = re.compile (a_pattern)
	result = p.search(n,0)
	if result:
		return True
	else:
		return False

def gitignore_content(n):
	myfile = open (n, 'r');
	file_lines = re.split ("\n", myfile.read())
	myfile.close ();
	return file_lines

def gitignore_in_folder (a_dir, rec=True):
	p = re.compile ("^.gitignore$")
	nodes = os.listdir (a_dir)
	r = []
	for n in nodes:
		fn = os.path.join (a_dir, n)
		if os.path.isdir (fn) and rec:
			sr = gitignore_in_folder (fn, rec)
			for i in sr:
				r.append ({'dir':i['dir'], 'file':i['file']})
		else:
			result = p.search(n,0)
			if result:
				#print "dir=%s file=%s" % (a_dir, n)
				lines = gitignore_content(os.path.join(a_dir, n))
				for l in lines:
					if is_wanted_file(l):
						r.append ({'dir':a_dir, 'file':l})
					elif l == "spec":
						if rec:
							sr = nodes_in_folder (os.path.join(a_dir, "spec", "ise"))
							for i in sr:
								r.append ({'dir':i['dir'], 'file':i['file']})
	return r

def main():
	os.chdir("..")
	os.chdir("..")
	l_target = os.path.join("ise","override", "generated")
	l_dir = ""

	sys.stderr.write ("Update override folder\n")
	sys.stderr.write ("* git status \n")

	#l_dir = a_src
	#e_file_p = re.compile ("^(\?|I).*%s(.*)\.e\s*$" % (regexp_escape(l_dir)));
	#dir_p = re.compile ("^(\?|I).*%s([^\.]*)\s*$" % (regexp_escape(l_dir)));
	spec_pat = "spec" + os.sep
	spec_ise_pat = os.path.join ("spec", "ise")

	sys.stderr.write ("* clean current files from \"%s\" ...\n" % (l_target))
	clean_folder (l_target)

	sys.stderr.write ("* copy files to \"%s\" ...\n" % (l_target))

	lines = re.split ("\n", get_output ("git status"))
	untracked_files_found = -1
	r = []
	for l in lines:
		if untracked_files_found != 0:
			if untracked_files_found > 0:
				untracked_files_found = untracked_files_found - 1
			elif len(l) > 0 and (l.startswith("# Untracked files:")):
				untracked_files_found = 2
		else:
			if len(l) > 0 and (l[0] == '#'):
				fn = string.strip(l[1:])
				if is_wanted_file(fn):
					sp = fn.rsplit('/', 1)
					d = ""
					for d_i in (sp[0]).split('/'):
						d = os.path.join(d, d_i)
					r.append ({'dir':d, 'file':sp[1]})

	sr = gitignore_in_folder(os.path.join(l_dir, "library"))
	for i in sr:
		r.append ({'dir':i['dir'], 'file':i['file']})
	sr = gitignore_in_folder(os.path.join(l_dir, "src"))
	for i in sr:
		r.append ({'dir':i['dir'], 'file':i['file']})

	nb = 0
	for i in r:
#		print ">> %s - %s" % (i['dir'], i['file'])
		d = i['dir']
		#d = d[1+len(l_dir):]
		update_node (l_dir, l_target, d, i['file'])
		nb = nb + 1
	sys.stderr.write ("* completed - %d file(s) copied - \n" % (nb))


if __name__ == "__main__":
	main()
	sys.exit()

