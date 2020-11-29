-- #
-- # sp_keyboard_search_by_script_iso15924_code
-- #

DROP PROCEDURE IF EXISTS sp_keyboard_search_by_script_iso15924_code;
GO

CREATE PROCEDURE sp_keyboard_search_by_script_iso15924_code
  @prmSearchText nvarchar(250),
  @prmPlatform nvarchar(32),
  @prmObsolete bit,
  @prmPageNumber int,
  @prmPageSize int
AS
BEGIN
  SET NOCOUNT ON;

  declare @tt_langtag tt_keyboard_search_langtag
  declare @tt_keyboard tt_keyboard_search_keyboard

  declare @weight_script INT = 5

  -- #
  -- # Search across script names
  -- #

  insert @tt_langtag select * from f_keyboard_search_langtag_by_script_iso15924_code(@prmSearchText+'%', @weight_script)

  -- #
  -- # Add all script matches to the keyboards temp table, with appropriate weights
  -- #

  insert @tt_keyboard select * from f_keyboard_search_keyboards_from_langtags(@prmPlatform, @tt_langtag)

  -- #
  -- # Build final list of results; two result sets: summary data and current page result
  -- #

  SET NOCOUNT OFF;

  select * from f_keyboard_search_statistics(@prmPageSize, @prmPageNumber, @prmObsolete, @tt_keyboard)
  select * from f_keyboard_search_results(@prmPageSize, @prmPageNumber, @prmObsolete, @tt_keyboard)
END
GO
