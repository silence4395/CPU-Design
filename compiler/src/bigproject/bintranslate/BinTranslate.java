package bigproject.bintranslate;

import java.io.BufferedWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.Set;

public class BinTranslate {
 
	List<String> code = null;
	List< List<String> > complexcode = null; 
	List<String> bincode = null;
	Hashtable<String, Integer> labels = new Hashtable<String, Integer>();
	
	public BinTranslate(List<String> a) {
		code = a;
		int i;
		for (i = 0; i < code.size(); i++)
			if (code.get(i).startsWith("main:"))
				break;
		code.add(i+1, "li $sp, 60000"); // FIXME 30000 is too small
		bincode = new ArrayList<String>();
		complexcode = new ArrayList< List<String> >();
	}

	public void work() {
		for (int i = 0; i < code.size();) {
			String line = code.get(i);
			while ((line.charAt(0) == '\t') ||
					(line.charAt(0) == '!'))
				line = line.substring(1);
			if (line.contains("#"))
				line = line.substring(0, line.indexOf('#'));
			while (line.endsWith(" "))
				line = line.substring(0, line.length()-1);
			if (line.charAt(0) == '.')
				code.remove(i);
			else {
				code.set(i, line);
				i = i + 1;
			}
		}
		
		List<String> items = null;
		for (int i = 0; i < code.size();) {
			String line = code.get(i);
			if (line.startsWith("bgt ") || line.startsWith("bge ")) {
				items = split_three_comma(line.substring(line.indexOf(' ')+1));
				String t;
				if (line.startsWith("bge ")) {
					if (!items.get(1).startsWith("$")) {
						int num = Integer.parseInt(items.get(1));
						t = "li $at, " + num;
						code.set(i, t);
						t = "bge " + items.get(0) + ", $at, " + items.get(2);
						code.add(i+1, t);
					} else {
						i = i + 1;
					}
				} else if (line.startsWith("bgt ")) {
					if (items.get(1).startsWith("$")) {
						t = "addi $at, " + items.get(1) + ", 1";
					} else {
						int num = Integer.parseInt(items.get(2)) + 1;
						t = "li $at, " + num;
					}
					code.set(i, t);
					t = "bge " + items.get(0) + ", $at, " + items.get(2);
					code.add(i+1, t);
				}
			} else if (line.startsWith("li ")) {
				items = split_two_comma(line.substring(line.indexOf(' ')+1));
				int num = Integer.parseInt(items.get(1));
				String binnum = toCompCode(num);
				binnum = extendTo(binnum, 32);
				int firstnum = compToInt(binnum.substring(0, 16));
				if (firstnum == 0) {
					String t = "ori " + items.get(0) + ", $r0, " + Integer.toString(num);
					code.set(i, t);
				} else {
					String t = "lui " + items.get(0) + ", ";
					String t2 = "ori " + items.get(0) + ", " + items.get(0) + ", ";
					t = t + Integer.toString(firstnum);
					code.set(i, t);
					t2 = t2 + Integer.toString(compToInt(binnum.substring(16)));
					code.add(i+1, t2);
				}
			} else {
				i = i + 1;
			}
		}
		
		List< Set<Integer> > use = getUse(code);
		List< Set<Integer> > def = getDef(code);
		int address = 0;
		boolean[] flag = new boolean[100000];
		for (int i = 0; i < code.size(); i++)
			flag[i] = false;
		for (int i = 0; i < code.size();) {
			if (flag[i]) {
				i = i + 1;
				continue;
			}
			String line = code.get(i);
			List<String> list = new ArrayList<String>();
			if (line.endsWith(":")) {
				labels.put(line.substring(0, line.length()-1), new Integer(address));
				i = i + 1;
			} else {
				Set<Integer> useset = new HashSet<Integer>();
				Set<Integer> defset = new HashSet<Integer>();
				int j = 0;
				boolean passflag = false;
				boolean memflag = false;
				while ((list.size() < 4) && (j < 20) && 
						(i+j < code.size())) {
					if (flag[i+j]) {
						j = j + 1;
						continue;
					}
					String t = code.get(i+j);
					if (t.endsWith(":"))
						break;
					if (hasHazard(useset, defset, use.get(i+j), def.get(i+j))) {
						useset.addAll(use.get(i+j));
						defset.addAll(def.get(i+j));
						if (isJump(t))
							break;
						passflag = true;
						j = j + 1;
						continue;
					}
					if ((t.startsWith("lw") || t.startsWith("sw")) && memflag) {
						useset.addAll(use.get(i+j));
						defset.addAll(def.get(i+j));
						passflag = true;
						j = j + 1;
						continue;
					}
					if (isJump(t) && passflag)
						break;
					if (t.startsWith("lw") || (t.startsWith("sw"))) {
						memflag = true;
						list.add(0, t);
					} else {
						list.add(t);
					}
					flag[i+j] = true;
					if (isJump(t))
						break;
					useset.addAll(use.get(i+j));
					defset.addAll(def.get(i+j));
					j = j + 1;
				}
				while (list.size() < 4)
					list.add("nop");
				complexcode.add(list);
				address = address + 1;
				i = i + 1;
			}
		}
		/*
		for (List<String> list: complexcode) {
			for (String str: list)
				System.out.println(str);
			System.out.println();
		}
		*/
		address = 0;
		for (int i = 0; i < complexcode.size(); i++) {
			List<String> lines = complexcode.get(i);
			String str = "";
			for (String line: lines)
				str = str + translate(line, address);
			bincode.add(str);
			address = address + 1;
		}
	}
	
	private boolean hasHazard(Set<Integer> use, Set<Integer> def,
			Set<Integer> use2, Set<Integer> def2) {
		Set<Integer> temp = new HashSet<Integer>();
		temp.addAll(use);
		temp.retainAll(def2);
		if (!temp.isEmpty())
			return true;
		temp.clear();
		temp.addAll(def);
		temp.retainAll(def2);
		if (!temp.isEmpty())
			return true;
		temp.clear();
		temp.addAll(def);
		temp.retainAll(use2);
		if (!temp.isEmpty())
			return true;
		return false;
	}

	private boolean isJump(String line) {
		return line.startsWith("j ") ||
				line.startsWith("jal ") ||
				line.startsWith("jr ") ||
				line.startsWith("bge ");
	}

	private List< Set<Integer> > getDef(List<String> code) {
		List< Set<Integer> > result = new ArrayList< Set<Integer> >();
		for (String line: code) {
			Set<Integer> set = new HashSet<Integer>();
			String itemstr = line.substring(line.indexOf(' ')+1);
			List<String> items = null;			
			if (line.startsWith("addi ") ||
					line.startsWith("addiu ") ||
					line.startsWith("ori ") ||
					line.startsWith("sll ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("lui ")) {
				items = split_two_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("lw ")) {
				items = split_three_offset(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("move ")) {
				items = split_two_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("mul ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("add ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
			} else if (line.startsWith("jal ")) {
				set.add(new Integer(toRegInt("$ra")));
			}
			result.add(set);
		}
		return result;
	}

	private List< Set<Integer> > getUse(List<String> code) {
		List< Set<Integer> > result = new ArrayList< Set<Integer> >();
		for (String line: code) {
			Set<Integer> set = new HashSet<Integer>();
			String itemstr = line.substring(line.indexOf(' ')+1);
			List<String> items = null;			
			if (line.startsWith("addi ") ||
					line.startsWith("addiu ") ||
					line.startsWith("ori ") ||
					line.startsWith("sll ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(1))));
			} else if (line.startsWith("lw ")) {
				items = split_three_offset(itemstr);
				set.add(new Integer(toRegInt(items.get(2))));
			} else if (line.startsWith("sw ")) {
				items = split_three_offset(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
				set.add(new Integer(toRegInt(items.get(2))));
			} else if (line.startsWith("move ")) {
				items = split_two_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(1))));
			} else if (line.startsWith("bge ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(0))));
				set.add(new Integer(toRegInt(items.get(1))));
			} else if (line.startsWith("mul ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(1))));
				if (items.get(2).startsWith("$"))
					set.add(new Integer(toRegInt(items.get(2))));
			} else if (line.startsWith("add ")) {
				items = split_three_comma(itemstr);
				set.add(new Integer(toRegInt(items.get(1))));
				set.add(new Integer(toRegInt(items.get(2))));
			} else if (line.startsWith("jr ")) {
				set.add(new Integer(toRegInt(itemstr)));
			}
			result.add(set);
		}
		return result;
	}

	private String translate(String line, int address) {
		String itemstr = line.substring(line.indexOf(' ')+1);
		String binstr;
		List<String> items = null;
		if (line.equals("syshalt")) {
			return extendTo("1", 32);
		} else if (line.startsWith("addi ") ||	line.startsWith("addiu ")) {
			items = split_three_comma(itemstr);
			int imm = Integer.parseInt(items.get(2));
			binstr = "001000" + toRegStr(items.get(1)) 
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 16);
			return binstr;
		} else if (line.startsWith("ori ")) {
			items = split_three_comma(itemstr);
			int imm = Integer.parseInt(items.get(2));
			binstr = "001101" + toRegStr(items.get(1))
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 16);
			return binstr;
		} else if (line.startsWith("lui ")) {
			items = split_two_comma(itemstr);
			int imm = Integer.parseInt(items.get(1));
			binstr = "001111" + "00000" 
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 16);
			return binstr;
		} else if (line.startsWith("sw ")) {
			items = split_three_offset(itemstr);
			int imm = Integer.parseInt(items.get(1)) / 4;
			binstr = "101011" + toRegStr(items.get(2))
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 16);
			return binstr;
		} else if (line.startsWith("move ")) {
			items = split_two_comma(itemstr);
			binstr = "011001" + toRegStr(items.get(1))
					+ toRegStr(items.get(0))
					+ zeroExtendTo("0", 16);
			return binstr;
		} else if (line.startsWith("bge ")) {
			items = split_three_comma(itemstr);
			int pos = labels.get(items.get(2));
			binstr = "011010" + toRegStr(items.get(0))
					+ toRegStr(items.get(1))
					+ extendTo(toCompCode(pos-address-1), 16);
			return binstr;
		} else if (line.startsWith("mul ")) {
			items = split_three_comma(itemstr);
			if (items.get(2).startsWith("$")) {
				binstr = "011000" + toRegStr(items.get(1))
						+ toRegStr(items.get(2))
						+ toRegStr(items.get(0))
						+ zeroExtendTo("0", 11);
			} else {
				int imm = Integer.parseInt(items.get(2));
				binstr = "011011" + toRegStr(items.get(1))
						+ toRegStr(items.get(0))
						+ extendTo(toCompCode(imm), 16);
			}
			return binstr;
		} else if (line.startsWith("add ")) {
			items = split_three_comma(itemstr);
			binstr = "000000" + toRegStr(items.get(1))
					+ toRegStr(items.get(2))
					+ toRegStr(items.get(0))
					+ "00000" + "100000";
			return binstr;
		} else if (line.startsWith("sll ")) {
			items = split_three_comma(itemstr);
			int imm = Integer.parseInt(items.get(2));
			binstr = "000000" + "00000"
					+ toRegStr(items.get(1)) 
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 5)
					+ zeroExtendTo("0", 6);
			return binstr;
		} else if (line.startsWith("lw ")) {
			items = split_three_offset(itemstr);
			int imm = Integer.parseInt(items.get(1)) / 4;
			binstr = "100011" + toRegStr(items.get(2))
					+ toRegStr(items.get(0))
					+ extendTo(toCompCode(imm), 16);
			return binstr;
		} else if (line.startsWith("j ")) {
			int pos = labels.get(itemstr).intValue();
			binstr = "000010" + zeroExtendTo(Integer.toBinaryString(pos), 26);
			return binstr;
		} else if (line.startsWith("jal ")) {
			int pos = labels.get(itemstr).intValue();
			binstr = "000011" + zeroExtendTo(Integer.toBinaryString(pos), 26);
			return binstr;
		} else if (line.startsWith("jr ")) {
			binstr = "000000" + toRegStr(itemstr)
					+ zeroExtendTo("0", 15)
					+ "001000";
			return binstr;
		} else if (line.equals("nop")) {
			binstr = zeroExtendTo("0", 32);
			return binstr;
		} else {
			System.out.println(line);
			return "";
		}
	}

	private String zeroExtendTo(String string, int l) {
		while (string.length() < l)
			string = "0" + string;
		return string;
	}

	// "$v0, 10($t0)" ==> "$v0" "10" "$t0"
	private List<String> split_three_offset(String line) {
		List<String> result = split_two_comma(line);
		String tstr = result.get(1);
		result.add(tstr.substring(tstr.indexOf('(')+1, tstr.indexOf(')')));
		result.set(1, tstr.substring(0, tstr.indexOf('(')));
		return result;
	}

	String[] regnames = {
			"$r0", "$at", "$v0", "$v1", "$a0", "$a1", "$a2",
			"$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5",
			"$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4",
			"$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1",
			"$gp", "$sp", "$fp", "$ra"
	};

	private int toRegInt(String name) {
		for (int i = 0; i < regnames.length; i++)
			if (regnames[i].equals(name))
				return i;
		System.out.println("error in toRegInt()!");
		return -1;
	}
	
	private String toRegStr(String name) {
		for (int i = 0; i < regnames.length; i++)
			if (regnames[i].equals(name))
				return zeroExtendTo(Integer.toBinaryString(i), 5);
		return null;
	}

	// "$v0, $t0, 10" ==> "$v0" "$t0" "10"
	private List<String> split_three_comma(String line) {
		List<String> result = new ArrayList<String>();
		result.add(line.substring(0, line.indexOf(',')));
		line = line.substring(line.indexOf(' ')+1);
		result.addAll(split_two_comma(line));
		return result;
	}

	private int binToInt(String string) {
		int ans = 0;
		for (int i = 0; i < string.length(); i++) {
			ans = ans * 2;
			if (string.charAt(i) == '1')
				ans = ans + 1;
		}
		return ans;
	}
	
	private int compToInt(String string) {
		if (string.startsWith("1")) {
			String newstr = "";
			for (int i = 0; i < string.length(); i++)
				if (string.charAt(i) == '0')
					newstr = newstr + '1';
				else
					newstr = newstr + '0';
			return -(binToInt(newstr)+1);
		} else
			return binToInt(string);
	}

	private String extendTo(String string, int l) {
		while (string.length() < l)
			string = string.charAt(0) + string;
		if (string.length() == l + 1)
			if (string.startsWith("0"))
				return string.substring(1);
		return string;
	}

	private String toCompCode(int num) {
		if (num >= 0)
			return "0" + Integer.toBinaryString(num);
		else {
			String t = Integer.toBinaryString(num);
			while (t.startsWith("11"))
				t = t.substring(1);
			return t;
		}
	}

	// "$v0, 10" ==> "$v0" "10"
	private List<String> split_two_comma(String line) {
		List<String> result = new ArrayList<String>();
		result.add(line.substring(0, line.indexOf(',')));
		result.add(line.substring(line.indexOf(' ')+1));
		return result;
	}

	public void printToFile(BufferedWriter writer) throws IOException {
		writer.write("@00");
		writer.newLine();
		for (String line: bincode) {
			writer.write(line);
			writer.newLine();
		}
		writer.write(extendTo("1", 32));
		writer.newLine();
	}

}
