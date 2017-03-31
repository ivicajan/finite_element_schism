grd_arr=GRID_GetArraySimple('/home/ivica/hioos/grid/roms-hiomsg-grid.nc');
out=GRID_ToTriangulation_V4(grd_arr);
clf;
trisurf(out.TheRecord.ListTrig,out.TheRecord.ListNode(:,1),out.TheRecord.ListNode(:,2),out.TheRecord.ListBathy);
south.ele=out.TheRecord.ListTrig;south.x=out.TheRecord.ListNode(:,1);
south.y=out.TheRecord.ListNode(:,2);south.z=out.TheRecord.ListBathy;
