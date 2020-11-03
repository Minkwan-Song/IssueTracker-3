/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
/* eslint-disable no-await-in-loop */
import db from "@providers/database";
import Model from "@models/model";
import { Issue } from "@interfaces/issue";

class IssueModel extends Model {
  protected tableName: string;

  constructor() {
    super();
    this.tableName = "ISSUE";
  }

  async select<T>(): Promise<any> {
    let data = await db.query(`select * from ${this.tableName}`);
    const issue = [...data[0]];
    for (const idx in issue) {
      const element = issue[idx];
      data = await db.query(`select * from TAG t join LABEL l on t.label_id = l.id where t.issue_id = ${element.id}`);
      issue[idx].labels = [...data[0]];
      data = await db.query(`select * from ASSIGNEE a join USER u on a.user_id = u.id where  a.issue_id= ${element.id}`);
      issue[idx].assignee = [...data[0]];
      data = await db.query(`select * from MILESTONE m where m.id = ${element.milestone_id}`);
      issue[idx].milestone = [...data[0]];
    }
    return issue;
  }

  async add(pData: Issue): Promise<number> {
    const insertId = await super.insert(pData, this.tableName);
    return insertId;
  }

  async edit(pData: Issue): Promise<number> {
    const affectedId = await super.update(pData, this.tableName);
    return affectedId;
  }

  async del(id: number): Promise<number> {
    const affectedId = await super.delete(id, this.tableName);
    return affectedId;
  }

  async changeState(id: number, state: boolean): Promise<number> {
    const data = { id, state };
    const affectedId = await super.update(data, this.tableName);
    return affectedId;
  }
}
export default new IssueModel();
