import React from 'react';
import { useParams } from 'react-router-dom';
import styled from '@emotion/styled';

import Sidebar from './Sidebar';
import View from './View';
import Add from './Add';

import { colors } from '../../constants';

const Root = styled.div`
  display: flex;

  width: 100%;
  height: 100%;
`;

const SidebarPane = styled.div`
  min-width: 250px;

  border-right: 1px solid ${colors.black};
`;

const MainPane = styled.div`
  width: 100%;
`;

const AddPane = styled.div`
  position: absolute;
  bottom: 15px;
  right: 15px;
`;

function Reader() {
  const params = useParams();
  const boardId = params.boardId;
  const feedId = params.feedId;

  return (
    <Root>
      <SidebarPane>
        <Sidebar boards={[{ id: 1, name: "Read Later" }]} feeds={[]} />
      </SidebarPane>

      <MainPane>
        <View />
      </MainPane>

      <AddPane>
        <Add />
      </AddPane>
    </Root>
  );
}

export default Reader;
