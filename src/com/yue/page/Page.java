package com.yue.page;

import org.springframework.stereotype.Component;

/*
 * page is a json parameter from jsp post, it contains page,rows,sort and order
 * In page entity, I get page and rows from json. Then I calculate offset for SQL row number
 */

@Component
public class Page {
	private int page;
	private int rows;		// number of rows per page	
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}
	/*
	 *  return offSet 
	 *  SQL rows as "limit ${offset}, ${rows}"
	 */
	public int getOffset() {
		return (page - 1) * rows;
	}
}
