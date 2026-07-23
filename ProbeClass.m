classdef ProbeClass < handle
    properties
        tubeLength = 0.04; % meters (40mm)
        tubeRadius = 0.003; % meters (6mm)
        tubeWallThickness = 0.00065; % meters (.65mm)
        tubeRadialResolution = 32; % for piezo tube scanner
        tubeLateralResolution = 72; % for piezo tube scanner
        polyRadius
        tX
        tY
        tZ
        reftX
        reftY
        reftZ
        previewtX
        previewtY
        previewtZ
        testVal
        tubeEndPosXInt
        tubeEndNegXInt
        tubeEndPosYInt
        tubeEndNegYInt
        pTubeEndPosXInt
        pTubeEndNegXInt
        pTubeEndPosYInt
        pTubeEndNegYInt
        voltageX
        voltageY
        voltageZ

        xRadiusOfCurvature;
        yRadiusOfCurvature;
        exagerationFactor;
        

        %define tip here
        tipLength = 0.010; % meters (10mm)
        tipStartXPos = 0;
        tipStartYPos = 0;
        tipStartZPos = 0;
        tipEndXPos = 0;
        tipEndYPos = 0;
        tipEndZPos = 0;
        tipPointingVec;

        %define state stuff here
    end
    methods
        function obj = ProbeClass(testValInput, exagerationFactor)
            % initialize tube geometry
            obj.exagerationFactor = exagerationFactor;
            obj.polyRadius = ones(1,obj.tubeLateralResolution)*obj.tubeRadius; % geometry describing tube
            [obj.tX,obj.tY,obj.tZ] = cylinder(obj.polyRadius,obj.tubeRadialResolution); 
            obj.tZ = obj.tZ * obj.tubeLength;
            obj.testVal = testValInput;
            obj.reftX = obj.tX;
            obj.reftY = obj.tY;
            obj.reftZ = obj.tZ;
            obj.previewtX = obj.tX;
            obj.previewtY = obj.tY;
            obj.previewtZ = obj.tZ;


            updateTipLocation(obj);
        end
        % fucntion = apply voltage
        % fucntion = update state
        function updateVerticeLocations(obj)
            % k = 1:length(obj.reftX);

            n = length(obj.reftX(:,25));
            n2 = length(obj.reftX(1,:));
            for p=1:n2
            % p=1;
                for k=1:n
                    r = obj.xRadiusOfCurvature - obj.reftX(end,p);
                    theta = (obj.tubeLength/(n*obj.xRadiusOfCurvature))*k;
                    obj.tX(n-k+1,p) = obj.reftX(n-k+1,p) + (r - r*cos(theta));
                    obj.previewtX(n-k+1,p) = obj.reftX(n-k+1,p) + (r - r*cos(theta))*obj.exagerationFactor;

                    obj.previewtZ(n-k+1,p) = obj.reftZ(end,p) - (r*sin(theta));

                    % r = obj.yRadiusOfCurvature - obj.reftY(end,p);
                    % theta = (obj.tubeLength/(n*obj.yRadiusOfCurvature))*k;
                    % obj.tY(n-k+1,p) = obj.reftY(n-k+1,p) + (r - r*cos(theta));
                    % obj.previewtY(n-k+1,p) = obj.reftY(n-k+1,p) + (r - r*cos(theta))*obj.exagerationFactor;
    
                end
            end
            % obj.tX(:,9) = obj.reftX(:,9) + 
            %obj.xRadiusOfCurvature-obj.xRadiusOfCurvature*cos(((obj.tubeLength)/(length(obj.reftX)*obj.xRadiusOfCurvature))*k);
            obj.tZ(:,25);
            % obj.tY(:,25)
        end

        function calculateRadiusOfBending(obj, xVoltage, yVoltage)
            obj.xRadiusOfCurvature = (3.141592653589793*(obj.tubeRadius*2)*obj.tubeLength)/((5.656854249492381)*(-2.65*10^-10)*xVoltage);
            obj.yRadiusOfCurvature = (3.141592653589793*(obj.tubeRadius*2)*obj.tubeLength)/((5.656854249492381)*(-2.65*10^-10)*yVoltage);
        end

        function updateTipLocation(obj)
            % obj.tZ(1,1) = obj.tZ(1,1)-.001;
            obj.tubeEndPosXInt = [obj.tX(1,1),obj.tY(1,1),obj.tZ(1,1)];
            obj.tubeEndNegXInt = [obj.tX(1,17),obj.tY(1,17),obj.tZ(1,17)];
            obj.tubeEndPosYInt = [obj.tX(1,9),obj.tY(1,9),obj.tZ(1,9)];
            obj.tubeEndNegYInt = [obj.tX(1,9),obj.tY(1,25),obj.tZ(1,25)];

            obj.pTubeEndPosXInt = [obj.previewtX(1,1),obj.previewtY(1,1),obj.previewtZ(1,1)];
            obj.pTubeEndNegXInt = [obj.previewtX(1,17),obj.previewtY(1,17),obj.previewtZ(1,17)];
            obj.pTubeEndPosYInt = [obj.previewtX(1,9),obj.previewtY(1,9),obj.previewtZ(1,9)];
            obj.pTubeEndNegYInt = [obj.previewtX(1,9),obj.previewtY(1,25),obj.previewtZ(1,25)];

            obj.tipStartXPos = (obj.tubeEndPosXInt(1)+obj.tubeEndNegXInt(1))/2;
            obj.tipStartYPos = (obj.tubeEndPosYInt(2)+obj.tubeEndNegYInt(2))/2;
            obj.tipStartZPos = (obj.tubeEndPosXInt(3)+obj.tubeEndNegXInt(3)+obj.tubeEndPosYInt(3)+obj.tubeEndNegYInt(3))/4;

            % These are vectors which point along what would be a line
            % connecting these points
            xPointingVec = [obj.tubeEndPosXInt(1) - obj.tubeEndNegXInt(1), 0, obj.tubeEndPosXInt(3) - obj.tubeEndNegXInt(3)];
            yPointingVec = [0, obj.tubeEndPosYInt(2) - obj.tubeEndNegYInt(2), obj.tubeEndPosYInt(3) - obj.tubeEndNegYInt(3)];

            obj.tipPointingVec = cross(xPointingVec, yPointingVec);
            obj.tipPointingVec = obj.tipPointingVec / norm(obj.tipPointingVec);
            
            obj.tipEndXPos = obj.tipStartXPos - obj.tipPointingVec(1)*obj.tipLength;
            obj.tipEndYPos = obj.tipStartYPos - obj.tipPointingVec(2)*obj.tipLength;
            obj.tipEndZPos = obj.tipStartZPos - obj.tipPointingVec(3)*obj.tipLength;
        
        end
        function speak(obj) 
            disp("ProbeSpeak" + obj.testVal);
        end
    end
end