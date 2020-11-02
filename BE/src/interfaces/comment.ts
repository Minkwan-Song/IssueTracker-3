/* eslint-disable camelcase */
export interface Comment {
  id: number | null;
  issue_id: number;
  user_id: number;
  body: string;
  emoji: string;
  created_at: Date;
}
