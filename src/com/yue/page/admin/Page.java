package com.yue.page.admin;

import org.springframework.stereotype.Component;

/*
 * Page is used in role page and user page to display pagination 
 */

@Component
public class Page {
	private int page = 1;	// current page number, initiated as 1
	private int rows;		// number of rows per page	
	private int offset;		// used in SQL "limit offset rows"
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
	public int getOffset() {
		this.offset = (page - 1) * rows;
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	
}
