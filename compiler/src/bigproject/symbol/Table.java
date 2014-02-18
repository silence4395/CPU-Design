package bigproject.symbol;

class Binder {
	Object value;
	Symbol pretop;
	Binder tail;
	int level;

	Binder(Object v, Symbol p, Binder t, int l) {
		value = v;
		pretop = p;
		tail = t;
		level = l;
	}
}

public class Table {

	private java.util.Dictionary<Symbol, Binder> dict = new java.util.Hashtable<Symbol, Binder>();
	private Symbol top = null;
	private Binder marks = null;
	private int nowlevel = 0;

	/**
	 * Gets the object associated with the specified symbol in the Table.
	 */
	public Object get(Symbol key) {
		Binder e = dict.get(key);
		if (e == null)
			return null;
		else if (e.level <= nowlevel)
			return e.value;
		else
			return null;
	}

	/**
	 * Puts the specified value into the Table, bound to the specified Symbol.
	 */
	public void put(Symbol key, Object value) {
		dict.put(key, new Binder(value, top, dict.get(key), nowlevel));
		top = key;
	}
	
	/**
	 * Set current level to a symbol
	 */
	public void setLevel(Symbol key) {
		Binder e = dict.get(key);
		e.level = nowlevel;
	}

	/**
	 * Remembers the current state of the Table.
	 */
	public void beginScope() {
		marks = new Binder(null, top, marks, nowlevel);
		nowlevel = nowlevel + 1;
		top = null;
	}

	/**
	 * Restores the table to what it was at the most recent beginScope that has
	 * not already been ended.
	 */
	public void endScope() {
		while (top != null) {
			Binder e = dict.get(top);
			if (e.tail != null)
				dict.put(top, e.tail);
			else
				dict.remove(top);
			top = e.pretop;
		}
		top = marks.pretop;
		nowlevel = nowlevel - 1;
		marks = marks.tail;
	}

	/**
	 * Returns an enumeration of the Table's symbols.
	 */
	public java.util.Enumeration<Symbol> keys() {
		return dict.keys();
	}
	
	public boolean redeclAtSameLevel(Symbol key) {
		Binder e = dict.get(key);
		if ((e != null) && (e.level == nowlevel))
			return true;
		return false;
	}
	
}