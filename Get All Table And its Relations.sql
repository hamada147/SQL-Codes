SELECT
  TC.OWNER AS SCHEMA_NAME,
  TC.TABLE_NAME,
  TC.COLUMN_NAME,
  TC.NULLABLE,
  TC.DATA_TYPE,
  TC.DATA_LENGTH,
  TC.DATA_PRECISION,
  TC.DATA_DEFAULT AS DEFAULT_VALUE,
  -- ALL_TAB_COLUMNS
  COMM.COMMENTS,
  -- ALL_COL_COMMENTS
  CONSTR.CONSTRAINT_NAME,
  CONSTR.CONSTRAINT_TYPE,
  CONSTR.R_CONSTRAINT_NAME,
  CONSTR.SEARCH_CONDITION,
  -- ALL_CONSTRAINTS
  DECODE(
    CONSTR.CONSTRAINT_TYPE,
    'R',
    (
      SELECT
        TC1.TABLE_NAME
      FROM
        ALL_CONS_COLUMNS TC1
      WHERE
        TC1.OWNER = TC.OWNER
        AND TC1.CONSTRAINT_NAME = CONSTR.R_CONSTRAINT_NAME
        AND ROWNUM < 2
    ),
    NULL
  ) AS FORIGN_TABLE_NAME,
  DECODE (
  	CONSTR.CONSTRAINT_TYPE,
    'R', 
    (
      SELECT
        TC1.COLUMN_NAME
      FROM
        ALL_CONS_COLUMNS TC1
      WHERE
        TC1.OWNER = TC.OWNER
        AND TC1.CONSTRAINT_NAME = CONSTR.R_CONSTRAINT_NAME
        AND TC1.POSITION = CONS_COLUM.POSITION
    ),
    NULL
  ) AS FORIGN_COLUMN_NAME
FROM
  ALL_TAB_COLUMNS TC
  INNER JOIN ALL_COL_COMMENTS COMM ON COMM.OWNER = TC.OWNER
  AND COMM.TABLE_NAME = TC.TABLE_NAME
  AND COMM.COLUMN_NAME = TC.COLUMN_NAME
  INNER JOIN ALL_CONSTRAINTS CONSTR ON CONSTR.OWNER = TC.OWNER
  AND CONSTR.TABLE_NAME = TC.TABLE_NAME
  INNER JOIN ALL_CONS_COLUMNS CONS_COLUM ON CONS_COLUM.OWNER = TC.OWNER
  AND CONS_COLUM.CONSTRAINT_NAME = CONSTR.CONSTRAINT_NAME
  AND CONS_COLUM.TABLE_NAME = TC.TABLE_NAME
  AND CONS_COLUM.COLUMN_NAME = TC.COLUMN_NAME;