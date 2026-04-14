classdef ScreenClass < handle
    properties
        fig;
        grid;
        probeRef;
        sampleRef;
        scanRef;

        % the following values are defined to give callback functionality
        tubeX1Pos;
        tubeY1Pos;
        tubeX2Pos;
        tubeY2Pos;

        scanSpeed;
        scanRange;
        heightRange

        moveXPos;
        moveYPos;
        moveZPos;
        ease;

        tipSurfaceDistance;
        biasVoltage;

        varTable1;
        varTable2;
        dispTable1;
        dispTable2;

        consoleLog = strings(255, 1)
        consoleIndex = 1;
        consoleTextBox;

        macroWindowSize;
        microWindowSize;
    end
    methods
        function obj = ScreenClass(probeRef, sampleRef, scanRef, macroWindowSize, microWindowSize)

            obj.probeRef = probeRef;
            obj.sampleRef = sampleRef;
            obj.scanRef = scanRef;
            % set up figure window and grid layout
            obj.fig = figure('Name', 'Probe View', 'NumberTitle','off');
            obj.grid = uigridlayout(obj.fig);
            obj.grid.RowHeight = {'1x','1x'};
            obj.grid.ColumnWidth = {'1x','1x','1x','1x'};
            obj.macroWindowSize = macroWindowSize;
            obj.microWindowSize = microWindowSize;

            % call respective methods which create each axis view or menu

            obj.createMenu1();
            obj.createAxis(1);
            obj.createAxis(2);
            obj.createAxis(3);
            obj.createMenu2();
            obj.createAxis(4);
            obj.createAxis(5);
            obj.createAxis(6);

            obj.probeRef.speak();


            %{
            
            
            button_ = uibutton(g());
            ax = uiaxes(g);
            ax = uiaxes(g);
            ax = uiaxes(g);
            ax = uiaxes(g);
            ax = uiaxes(g);
            ax = uiaxes(g);
            ax = uiaxes(g);
            axis equal
            tube = ProbeClass();
            surf(tube.tX,tube.tY,tube.tZ);
            xlim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]);
            ylim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]);
            zlim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]+0.015);
            title('Tip Probe 3D Macro View');
            xlabel('x-axis (m)');
            ylabel('y-axis (m)');
            zlabel('z-axis (m)');
            %}
            obj.log("ScreenClass Constructor Finished");
        end

        function createMenu1(obj)
            % create menu sub grid
            menuGrid = uigridlayout(obj.grid, 'Padding',4);
            menuGrid.RowHeight = {'1x','2x','1x'};
            menuGrid.ColumnWidth = {'1x'};

            % -------------------------------------------------------------
            % CREATE SCANNING MENU
            ScanImagePanel = uipanel(menuGrid, "Title", "Scan Image");
            scanPanelGrid = uigridlayout(ScanImagePanel, [3, 4], 'padding', [1,1,1,1]);
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'.33x','1x'};
            tubeX1Label = uilabel(scanPanelSqueezer, "Text", 'x1', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.tubeX1Pos = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", -1); % units in pixels (mapped nicely to meters)
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'.33x','1x'};
            tubeY1Label = uilabel(scanPanelSqueezer, "Text", 'y1', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.tubeY1Pos = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", 1); % and grab sample size!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'.33x','1x'};
            tubeX2Label = uilabel(scanPanelSqueezer, "Text", 'x2', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.tubeX2Pos = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", 1);
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'.33x','1x'};
            tubeY2Label = uilabel(scanPanelSqueezer, "Text", 'y2', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.tubeY2Pos = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", -1);
            % WHEN THESE EVENTUALLY DRIVE THE SCAN RANGE< MAKE SURE IT
            % FLOORS THE VALUE AFTER AN INT CHECK


            scanRangeLabel = uilabel(scanPanelGrid, "Text", 'Scan Range:', 'FontSize', 12, 'HorizontalAlignment', "right");
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'1x','1x'};
            obj.scanRange = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", 1);
            scanRangeUnitsLabel = uilabel(scanPanelSqueezer, "Text", 'μm', 'FontSize', 12);
            heightRangeLabel = uilabel(scanPanelGrid, "Text", 'Height Range:', 'FontSize', 12, 'HorizontalAlignment', "right");
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'1x','1x'};
            obj.heightRange = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", 1);
            scanRangeUnitsLabel = uilabel(scanPanelSqueezer, "Text", 'μm', 'FontSize', 12);





            scanSpeedLabel = uilabel(scanPanelGrid, "Text", 'Scan Speed:', 'FontSize', 12, 'HorizontalAlignment', "right");
            scanPanelSqueezer = uigridlayout(scanPanelGrid, [1,2], 'padding', 0);
            scanPanelSqueezer.ColumnWidth = {'1x','1x'};
            obj.scanSpeed = uieditfield(scanPanelSqueezer, "numeric", "Limits",[-5 10], "Value", 1);
            scanSpeedUnitsLabel = uilabel(scanPanelSqueezer, "Text", 'μm/s', 'FontSize', 12);

            maximizeButton = uibutton(scanPanelGrid, 'Text', 'Maximize', 'FontSize', 12);
            scanButton = uibutton(scanPanelGrid, 'Text', 'Scan Image', 'FontSize', 12);
            scanButton.ButtonPushedFcn = @obj.scanButtonCallback;

            % -------------------------------------------------------------

            % -------------------------------------------------------------
            % CREATE MOVING MENU
            movePanel = uipanel(menuGrid, "Title", "Move Probe Tip");
            sectionsGrid = uigridlayout(movePanel, [1, 3], 'padding', [1,1,1,1]);
            sectionsGrid.ColumnWidth = {'3.25x','1x','2.25x'};

            % left most navigation buttons
            leftGrid = uigridlayout(sectionsGrid, [3, 3], 'padding', [1,1,1,1]);
            leftGrid.RowHeight = {'1x','1x','1x'};
            leftGrid.ColumnWidth = {'1x','1x','1x'};
            upLeft = uibutton(leftGrid, 'Text', '-x +y', 'FontSize', 12);
            % upLeft.ButtonPushedFcn = @obj....;
            up = uibutton(leftGrid, 'Text', '+y', 'FontSize', 12);
            upRight = uibutton(leftGrid, 'Text', '+x +y', 'FontSize', 12);
            left = uibutton(leftGrid, 'Text', '-x', 'FontSize', 12);
            center = uibutton(leftGrid, 'Text', 'Center', 'FontSize', 12);
            right = uibutton(leftGrid, 'Text', '+x', 'FontSize', 12);
            downLeft = uibutton(leftGrid, 'Text', '-x -y', 'FontSize', 12);
            down = uibutton(leftGrid, 'Text', '-y', 'FontSize', 12);
            downRight = uibutton(leftGrid, 'Text', '+x -y', 'FontSize', 12);

            % middle height control
            middleGrid = uigridlayout(sectionsGrid, [3, 1], 'padding', [1,1,1,1]);
            middleGrid.RowHeight = {'1x','1x','1x'};
            middleGrid.ColumnWidth = {'1x'};
            raise = uibutton(middleGrid, 'Text', '+z', 'FontSize', 12);
            surface = uibutton(middleGrid, 'Text', 'Touch', 'FontSize', 12);
            lower = uibutton(middleGrid, 'Text', '-z', 'FontSize', 12);

            % right side exact positioning

            rightGrid = uigridlayout(sectionsGrid, [6, 1], 'padding', [1,1,1,1]);
            rightGrid.RowHeight = {'1x','1x','1x','1x','1x','1x'};
            rightGrid.ColumnWidth = {'1x'};

            % RENAME ALL THESE THINGSSSS! THEY WERE COPY
            % PASTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            moveSqueezer = uigridlayout(rightGrid, [1,3], 'padding', 0);
            moveSqueezer.ColumnWidth = {'1.5x','1.5x', '1x'};
            easeLabel = uilabel(moveSqueezer, "Text", 'Ease:', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.ease = uieditfield(moveSqueezer, "numeric", "Limits",[-10,10], "Value", 1); % set proper limits
            stepInfoButton = uibutton(moveSqueezer, 'Text', '?', 'FontSize', 12);
            % OPEN SMALL INFO WINDOW DESCRIBING WHAT STEP SIZE ACTUALLY
            % EQUATES TO PHYSICALLY
            moveSqueezer = uigridlayout(rightGrid, [1,2], 'padding', 0);
            moveSqueezer.ColumnWidth = {'.25x','1x'};
            moveXLabel = uilabel(moveSqueezer, "Text", '  x:', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.moveXPos = uieditfield(moveSqueezer, "numeric", "Limits",[-5 10], "Value", 0);
            moveSqueezer = uigridlayout(rightGrid, [1,2], 'padding', 0);
            moveSqueezer.ColumnWidth = {'.25x','1x'};
            moveYLabel = uilabel(moveSqueezer, "Text", '  y:', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.moveYPos = uieditfield(moveSqueezer, "numeric", "Limits",[-5 10], "Value", 0);
            moveSqueezer = uigridlayout(rightGrid, [1,2], 'padding', 0);
            moveSqueezer.ColumnWidth = {'.25x','1x'};
            moveZLabel = uilabel(moveSqueezer, "Text", '  z:', 'FontSize', 12, 'HorizontalAlignment', "right");
            obj.moveZPos = uieditfield(moveSqueezer, "numeric", "Limits",[-5 10], "Value", 0);
            % DISABLE Z EDIT FIELD IF BOX IS TICKED!!!!!!!!!!!!!!!!!!!!!!!!
            autoZCheck = uicheckbox(rightGrid, "Text", "Auto Z Height");
            moveButton = uibutton(rightGrid, 'Text', 'Move to xyz', 'FontSize', 12);


            % -------------------------------------------------------------
            % create settings menu
            settingsPanel = uipanel(menuGrid, "Title", "Settings");
            settingsGrid = uigridlayout(settingsPanel, [3, 1], 'padding', [1,1,1,1]);
            settingsGrid.RowHeight = {'1x','1x','1x'};
            settingsGrid.ColumnWidth = {'1x'};
            topGrid = uigridlayout(settingsGrid, [1, 3], 'padding', [1,1,1,1]);
            topGrid.RowHeight = {'1x'};
            topGrid.ColumnWidth = {'1.25x','1x','1x'};

            tipSurfaceDistanceLabel = uilabel(topGrid, "Text", 'Tip Surface Distance:', 'FontSize', 12, 'HorizontalAlignment', "right");
            settingsSqueezer = uigridlayout(topGrid, [1,2], 'padding', 0);
            settingsSqueezer.ColumnWidth = {'1x','1x'};
            obj.tipSurfaceDistance = uieditfield(settingsSqueezer, "numeric", "Limits",[-5 10], "Value", 0);
            scanSpeedUnitsLabel = uilabel(settingsSqueezer, "Text", 'nm', 'FontSize', 12);
            sampleText = uilabel(topGrid, "Text", 'sample text', 'FontSize', 12);

            middleGrid = uigridlayout(settingsGrid, [1, 4], 'padding', [1,1,1,1]);
            middleGrid.RowHeight = {'1x'};
            middleGrid.ColumnWidth = {'1x','1x','1x','1x'};

            biasVoltageLabel = uilabel(middleGrid, "Text", 'Bias Voltage', 'FontSize', 12, 'HorizontalAlignment', "right");
            settingsSqueezer = uigridlayout(middleGrid, [1,2], 'padding', 0);
            settingsSqueezer.ColumnWidth = {'1.5x','1x'};
            obj.biasVoltage = uieditfield(settingsSqueezer, "numeric", "Limits",[0 2000], "Value", 1000);
            scanSpeedUnitsLabel = uilabel(settingsSqueezer, "Text", 'mV', 'FontSize', 12);



            %{
            button = uibutton(menuGrid, 'Text', 'Click Me!');
            button.ButtonPushedFcn = @obj.myButtonCallback;
            button2 = uibutton(menuGrid);
            button3 = uibutton(menuGrid);
            %}
        end
        function createMenu2(obj)
            menuGrid = uigridlayout(obj.grid, 'Padding',4);
            menuGrid.RowHeight = {'2x','1x'};
            menuGrid.ColumnWidth = {'1x'};


            statusPanel = uipanel(menuGrid, "Title", "Variable Status");
            leftGrid = uigridlayout(statusPanel, [1, 2], 'padding', [1,1,1,1]);
            % leftGrid.RowHeight = {'1x','1x','1x','1x','1x','1x'};
            % leftGrid.ColumnWidth = {'1x','1x'};
            obj.varTable1 = ["Tip x Position:", obj.probeRef.tipEndXPos + " m";
                "Tip y Position:",obj.probeRef.tipEndYPos + " m";
                "Tip z Position:",obj.probeRef.tipEndZPos + " m";
                "Sample Height:",4;
                "+x Voltage:",5;
                "-x Voltage:",6;
                "+y Voltage:",6;
                "-y Voltage:",6;
                "+z Voltage:",6;
                "-z Voltage:",6;
                "Voltage Max:",6;
                "Voltage Min:",6;
                "Tip x Base Pos:", obj.probeRef.tipStartXPos + " m";
                "Tip y Base Pos:",obj.probeRef.tipStartYPos + " m";
                "Tip z Base Pos:",obj.probeRef.tipStartZPos + " m";];
            obj.varTable2 = ["Exageration Factor:",6;
                "Measured Current:", 1 + " nA";
                "Amplified Voltage:",1 + " μV";
                "Bias Voltage:",1 + " V";
                "Calculated Depth:",4;
                "Image x Pixel:",6;
                "Image y Pixel:",6;
                "Image Depth:",6;
                "x Tip Velocity:",5;
                "y Tip Velocity:",6;
                "z Tip Velocity:",6;
                "x Deflection Radius:",6;
                "y Deflection Radius:",6;
                "Tube Extension:",6;
                "z Net Offset:",6];
            obj.dispTable1 = uitable(leftGrid, "Data", obj.varTable1, "RowName", {}, "ColumnName", {"Variable", "Value"});
            obj.dispTable2 = uitable(leftGrid, "Data", obj.varTable2, "RowName", {}, "ColumnName", {"Variable", "Value"});

            consolePanel = uipanel(menuGrid, "Title", "Console");
            consoleGrid = uigridlayout(consolePanel, [1, 1], 'padding', [1,1,1,1]);

            obj.consoleTextBox = uilistbox(consoleGrid);
            % obj.consoleTextBox.ValueChangingFcn = @(src,event)obj.consoleEditCallback(src,event);


        end
        function createAxis(obj, type)
            plotWindow = uiaxes(obj.grid);
            switch (type)
                case 1
                    plotTitle = 'Tip Probe 3D Macro View';
                    xAxis = 'x-axis (m)';
                    yAxis = 'y-axis (m)';
                    zAxis = 'z-axis (m)';
                    probeSurf = surf(obj.probeRef.tX,obj.probeRef.tY,obj.probeRef.tZ, 'EdgeColor', 'none');%'#e6f5f3');
                    hold(plotWindow, 'on');
                    sampleSurfPreview = surf(obj.sampleRef.sMeshPreviewX, obj.sampleRef.sMeshPreviewY, obj.sampleRef.sMeshPreviewZ,  'EdgeColor', '#e6f5f3', 'FaceColor', '#1e6eae');
                    axis(plotWindow, 'equal');
                    xlim(plotWindow, [-obj.macroWindowSize*obj.probeRef.tubeRadius,obj.macroWindowSize*obj.probeRef.tubeRadius]);
                    ylim(plotWindow, [-obj.macroWindowSize*obj.probeRef.tubeRadius,obj.macroWindowSize*obj.probeRef.tubeRadius]);
                    zlim(plotWindow, [-obj.macroWindowSize*obj.probeRef.tubeRadius,obj.macroWindowSize*obj.probeRef.tubeRadius]+0.015);

                    plot3(obj.probeRef.tubeEndPosXInt(1),obj.probeRef.tubeEndPosXInt(2),obj.probeRef.tubeEndPosXInt(3),'bo','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    text(obj.probeRef.tubeEndPosXInt(1),obj.probeRef.tubeEndPosXInt(2),obj.probeRef.tubeEndPosXInt(3), 'posX')
                    plot3(obj.probeRef.tubeEndNegXInt(1),obj.probeRef.tubeEndNegXInt(2),obj.probeRef.tubeEndNegXInt(3),'bo','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    text(obj.probeRef.tubeEndNegXInt(1),obj.probeRef.tubeEndNegXInt(2),obj.probeRef.tubeEndNegXInt(3), 'negX')
                    plot3(obj.probeRef.tubeEndPosYInt(1),obj.probeRef.tubeEndPosYInt(2),obj.probeRef.tubeEndPosYInt(3),'bo','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    text(obj.probeRef.tubeEndPosYInt(1),obj.probeRef.tubeEndPosYInt(2),obj.probeRef.tubeEndPosYInt(3), 'posY')
                    plot3(obj.probeRef.tubeEndNegYInt(1),obj.probeRef.tubeEndNegYInt(2),obj.probeRef.tubeEndNegYInt(3),'bo','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    text(obj.probeRef.tubeEndNegYInt(1),obj.probeRef.tubeEndNegYInt(2),obj.probeRef.tubeEndNegYInt(3), 'negY')

                    plot3(obj.probeRef.tipStartXPos,obj.probeRef.tipStartYPos,obj.probeRef.tipStartZPos,'ro','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    plot3(obj.probeRef.tipEndXPos,obj.probeRef.tipEndYPos,obj.probeRef.tipEndZPos,'ro','MarkerSize', 6,'MarkerFaceColor','#FFFFFF')
                    plot3([obj.probeRef.tipStartXPos, obj.probeRef.tipEndXPos], [obj.probeRef.tipStartYPos, obj.probeRef.tipEndYPos], [obj.probeRef.tipStartZPos,obj.probeRef.tipEndZPos], '-', 'LineWidth', 3, 'Color','#e84fb2');



                    hold(plotWindow, 'off');

                case 2
                    plotTitle = 'Tip Probe 3D Micro View';
                    xAxis = 'x-axis (nm)';
                    yAxis = 'y-axis (nm)';
                    zAxis = 'z-axis (nm)';

                    sampleSurf = surf('parent', plotWindow, obj.sampleRef.sMeshX, obj.sampleRef.sMeshY, obj.sampleRef.sMeshZ,  'EdgeColor', '#95acb8');
                    hold(plotWindow, 'on');
                    verticePlot = plot3(plotWindow, obj.sampleRef.sMeshX, obj.sampleRef.sMeshY, obj.sampleRef.sMeshZ, '.', 'MarkerSize', 12, 'Color', 'white');
                    % verticePlot = rectangle(plotWindow, obj.sampleRef.sMeshX, obj.sampleRef.sMeshY, obj.sampleRef.sMeshZ, '.', 'MarkerSize', 10, 'Color', 'white');
                    
                    axis(plotWindow, 'equal');
                    xlim(plotWindow, [-obj.microWindowSize*obj.sampleRef.activeWidth,obj.microWindowSize*obj.sampleRef.activeWidth]);
                    ylim(plotWindow, [-obj.microWindowSize*obj.sampleRef.activeWidth,obj.microWindowSize*obj.sampleRef.activeWidth]);
                    zlimOffset = obj.sampleRef.sampleZPos+((obj.microWindowSize*obj.sampleRef.activeWidth)/1.5);
                    zlim(plotWindow, [-obj.microWindowSize*obj.sampleRef.activeWidth,obj.microWindowSize*obj.sampleRef.activeWidth]+zlimOffset);
                    colormap(plotWindow, "abyss");

                    hold(plotWindow, 'off');
                case 3
                    plotTitle = sprintf('Raster Scan: %.0fx%.0f',obj.scanRef.resolution, obj.scanRef.resolution);
                    xAxis = 'x-axis';
                    yAxis = 'y-axis';
                    zAxis = 'depth';


                    % imagesc(plotWindow, rand([4,4]));
                    imagesc(plotWindow, obj.scanRef.image, 'xData', .5, 'YData', .5);
                    axis(plotWindow, 'equal');
                    xlim(plotWindow, [0,obj.scanRef.resolution]);
                    ylim(plotWindow, [0,obj.scanRef.resolution]);
                    colormap(plotWindow, "hot");



                otherwise
                    plotTitle = 'Invalid createAxis type argument';
                    xAxis = 'x-axis';
                    yAxis = 'y-axis';
                    zAxis = 'z-axis';
                    disp('Invalid create Axis type argument');
                    obj.log('Invalid create Axis type argument');
            end
            title(plotWindow, plotTitle);
            xlabel(plotWindow, xAxis);
            ylabel(plotWindow, yAxis);
            zlabel(plotWindow, zAxis);

        end

        function log(obj, consoleMessage)
            timeStamp = datetime('now');
            timeStamp.Format = 'HH:mm:ss:ms';
            obj.consoleLog(obj.consoleIndex) = string(timeStamp) + ' - ' + consoleMessage;
            obj.consoleIndex = obj.consoleIndex + 1;
            obj.consoleTextBox.Items = obj.consoleLog;
            % obj.consoleTextBox.Value = 'hi';
            % disp("logging");
            scroll(obj.consoleTextBox, obj.consoleLog(obj.consoleIndex));
            % drawnow;
            % disp(class(obj.consoleTextBox))
            % disp(obj.consoleTextBox)
        end





        function scanButtonCallback(obj, src, event)
            disp('scanButton clicked!');
            obj.tubeX1Pos.Value = 5;
            % Add more functionality here (e.g., calculations, plotting, etc.)
            % uiwait(msgbox('You clicked the button!', 'Success'));
        end

        function speak(obj)
            disp("ScreenSpeak % calling ProbeSpeak...")
            obj.probeRef.speak();
        end
    end
end