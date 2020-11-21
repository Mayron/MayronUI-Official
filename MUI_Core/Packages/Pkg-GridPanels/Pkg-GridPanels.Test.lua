-- luacheck: ignore self 143 631
local obj = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
local GridPanels = obj:Import("GridPanels.Main"); ---@type Package
local Grid = GridPanels:Get("Grid");
local Region = GridPanels:Get("Region");
local ResponsiveScrollFrame = GridPanels:Get("ResponsiveScrollFrame");

local print = _G.print;
-------------------------------------------------

local function Creating_Grid_With_Regions_Test1()
  print("Creating_Grid_With_Regions_Test1 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid
  local regionA = Region(); ---@type Region
  regionA:SetName("Region A");

  local regionB = Region(); ---@type Region
  regionB:SetName("Region B");

  local regionC = Region(); ---@type Region
  regionC:SetName("Region C");

  -- Act
  grid:AddRegions(regionA, regionB, regionC);
  local returnedRegionA, returnedRegionB, returnedRegionC = grid:GetRegions();

  -- Assert
  obj:Assert(regionA:Equals(returnedRegionA), "%s does not equal returned region %s", regionA, returnedRegionA);
  obj:Assert(regionB:Equals(returnedRegionB), "%s does not equal returned region %s", regionB, returnedRegionB);
  obj:Assert(regionC:Equals(returnedRegionC), "%s does not equal returned region %s", regionC, returnedRegionC);

  print("Creating_Grid_With_Regions_Test1 Successful!");
end

local function Creating_Grid_With_Regions_Test2()
  print("Creating_Grid_With_Regions_Test2 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid
  local regionA = Region(); ---@type Region
  local regionB = Region(); ---@type Region
  local regionC = Region(); ---@type Region

  -- Act
  grid:AddRegions(regionA, regionB, regionC);

  -- Assert
  obj:Assert(grid:Equals(regionA:GetGrid()), "Region A's Grid is missing or is not as expected.");
  obj:Assert(grid:Equals(regionB:GetGrid()), "Region B's Grid is missing or is not as expected.");
  obj:Assert(grid:Equals(regionC:GetGrid()), "Region C's Grid is missing or is not as expected.");

  print("Creating_Grid_With_Regions_Test2 Successful!");
end

local function Set_And_Get_Grid_Dimensions_Test1()
  print("Set_And_Get_Grid_Dimensions_Test1 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid

  -- Act
  grid:SetDimensions(3, 5);
  local width, height = grid:GetDimensions();

  -- Assert
  obj:Assert(width == 3, "Unexpected Grid width dimension");
  obj:Assert(height == 5, "Unexpected Grid height dimension");

  print("Set_And_Get_Grid_Dimensions_Test1 Successful!");
end

-- This is a visual test! It should pass and you can view the results in WoW
local function Set_Fixed_And_Scaled_Values_To_Rows_And_Columns_Visual_Test1()
  print("Set_Fixed_And_Scaled_Values_To_Rows_And_Columns_Visual_Test1 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid
  grid:SetDevMode(true);
  grid:SetPoint("CENTER");
  grid:SetSize(800, 500);

  local regionA = Region(); ---@type Region
  regionA:SetSpanSize(1, 2);

  local regionB = Region(); ---@type Region
  regionB:SetSpanSize(2, 3);

  local regionC = Region(); ---@type Region

  -- Act
  grid:SetDimensions(3, 5);
  grid:AddRegions(regionA, regionB, regionC);

  local column1 = grid:GetColumn(1);
  column1:SetScale(2);

  local column3 = grid:GetColumn(3);
  column3:SetFixed(150);

  local row2 = grid:GetRow(2);
  row2:SetScale(0.5);

  local row5 = grid:GetRow(5);
  row5:SetFixed(200);

  print("Set_Fixed_And_Scaled_Values_To_Rows_And_Columns_Visual_Test1 Successful!");
end

-- If the height is set to 1 and the grid cannot fit all regions added, height should increase to fit
local function If_Not_Enough_Height_Dimension_Should_Scale_To_Fit_Test1()
  print("If_Not_Enough_Height_Dimension_Should_Scale_To_Fit_Test1 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid
  grid:SetDevMode(true);
  grid:SetPoint("CENTER");
  grid:SetSize(800, 500);

  local regionA = Region(); ---@type Region
  local regionB = Region(); ---@type Region
  local regionC = Region(); ---@type Region

  -- Act
  grid:SetDimensions(1, "auto");
  grid:AddRegions(regionA, regionB, regionC);

  print("If_Not_Enough_Height_Dimension_Should_Scale_To_Fit_Test1 Successful!");
end

local function If_Not_Enough_Width_Dimension_Should_Scale_To_Fit_Test1()
  print("If_Not_Enough_Width_Dimension_Should_Scale_To_Fit_Test1 Started");

    -- Arrange
    local grid = Grid(); ---@type Grid
    grid:SetDevMode(true);
    grid:SetPoint("CENTER");
    grid:SetSize(800, 500);

    local regionA = Region(); ---@type Region
    local regionB = Region(); ---@type Region
    local regionC = Region(); ---@type Region

    -- Act
    -- should ignore auto height and pick width to scale if both are "auto".
    -- i.e. this should be the same as grid:SetDimensions("auto", 1);
    grid:SetDimensions("auto", "auto");
    grid:AddRegions(regionA, regionB, regionC);

  print("If_Not_Enough_Width_Dimension_Should_Scale_To_Fit_Test1 Successful!");
end

local function Set_Region_Insets_Visual_Test1()
  print("Set_Region_Insets_Visual_Test1 Started");

  -- Arrange
  local grid = Grid(); ---@type Grid
  grid:SetDevMode(true);
  grid:SetPoint("CENTER");
  grid:SetSize(800, 500);

  local regionA = Region(); ---@type Region
  regionA:SetInsets(10) -- all insets should be 10

  local regionB = Region(); ---@type Region
  -- vertical insets should be 10 (top and bottom),
  -- horizontal insets should be 30 (left and right)
  regionB:SetInsets(10, 30);

  local regionC = Region(); ---@type Region
  -- top = 10, right = 30, bottom = 50, left = 80
  regionC:SetInsets(10, 30, 50, 80);

    -- Act
grid:SetDimensions(3, 1);
grid:AddRegions(regionA, regionB, regionC);

  print("Set_Region_Insets_Visual_Test1 Successful!");
end

local function CreateElement(width, height, globalName)
  local element = CreateFrame("Frame", globalName);
  element:SetSize(width, height);
  local texture = element:CreateTexture(nil, "BACKGROUND");
  texture:SetAllPoints(true);
  texture:SetColorTexture(math.random(), math.random(), math.random(), 0.5);

  return element;
end

local function ResponsiveScrollFrame_Test1()
  print("ResponsiveScrollFrame_Test1 Started");
  -- Act
  local frame = ResponsiveScrollFrame(nil, "ResponsiveScrollFrame_Test1"); ---@type ResponsiveScrollFrame
  frame:SetPoint("CENTER");
  frame:SetSize(400, 500);

  local texture = frame:CreateTexture(nil, "BACKGROUND");
  texture:SetAllPoints(true);
  texture:SetColorTexture(0, 0, 0, 0.5);

  local element1 = CreateElement(100, 50, "Test_Element1");
  local element2 = CreateElement(200, 100, "Test_Element2");
  local element3 = CreateElement(200, 200, "Test_Element3");
  local element4 = CreateElement(300, 500, "Test_Element4");

  frame:SetContainerPadding(30);
  frame:SetElementSpacing(10);
  frame:AddChildren(element1, element2, element3, element4);


  local dragger = CreateElement(30, 30, "Test_Dragger");
  dragger:SetPoint("BOTTOMRIGHT", frame:GetFrame(), "BOTTOMRIGHT");
  dragger:SetFrameStrata("DIALOG");
  frame:MakeResizable(dragger);

  print("ResponsiveScrollFrame_Test1 Successful!");
end

-- Run tests:
-- Creating_Grid_With_Regions_Test1();
-- Creating_Grid_With_Regions_Test2();
-- Set_And_Get_Grid_Dimensions_Test1();
-- Set_Fixed_And_Scaled_Values_To_Rows_And_Columns_Visual_Test1();
-- If_Not_Enough_Height_Dimension_Should_Scale_To_Fit_Test1();
-- If_Not_Enough_Width_Dimension_Should_Scale_To_Fit_Test1();
-- Set_Region_Insets_Visual_Test1();
-- ResponsiveScrollFrame_Test1();