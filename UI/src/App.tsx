import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import styled from '@emotion/styled';

import Reader from './components/reader/Reader';

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

function App() {
  return (
    <Root>
      <Router>
        <Routes>
          <Route path="/" element={<Reader />} />
          <Route path="/feeds/:feedId" element={<Reader />} />
          <Route path="/boards/:boardId" element={<Reader />} />
        </Routes>
      </Router>
    </Root>
  );
}

export default App;
