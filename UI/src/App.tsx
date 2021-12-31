import React from 'react';
import styled from '@emotion/styled';

import Sidebar from './components/Sidebar';
import View from './components/View';
import Add from './components/Add';

import './global-styles';
import { colors } from './constants';

const Root = styled.div`
  position: relative;
  display: flex;

  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;

  color: ${colors.black};
  font-family: 'Roboto', sans-serif;
  font-weight: 100;
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

function App() {
  return (
    <Root>
      <SidebarPane>
        <Sidebar />
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

export default App;
