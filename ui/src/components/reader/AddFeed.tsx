import React, { useState } from 'react';
import styled from '@emotion/styled';

import Card from '../common/Card';
import Submit from '../common/Submit';

import { colors } from '../../constants';

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 30px;

  font-size: 22px;
`;

const ErrorLabel = styled.div`
  height: 20px;

  font-size: 14px;
`;

const Label = styled.div`
  padding-bottom: 3px;
`;

const Spacer = styled.div`
  height: 10px;
`;

const Textbox = styled.input`
  display: block;
  box-sizing: border-box;

  width: 100%;
  height: 35px;

  padding-left: 10px;
  padding-right: 10px;

  border: 1px solid ${colors.lightBlack};
  border-radius: 5px;

  font-size: 15px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;
`;

interface Props {
  onSubmit: () => void;
}

function AddFeed({ onSubmit }: Props) {
  const [source, setSource] = useState('');
  const [error, setError] = useState('');
  const _onSubmit = (event: any) => {
    event.preventDefault();
    console.log("TESTESTEST");
    onSubmit();
  }

  return (
    <Card style={{ width: "300px", height: "200px" }}>
      <Title>Add Feed</Title>

      <form onSubmit={_onSubmit}>
        <Label>URL:</Label>
        <Textbox type="text" onChange={(event) => setSource(event.target.value)} required />
        <Spacer />
        
        <ErrorLabel>{error}</ErrorLabel>

        <Submit>Add</Submit>
        <input type="submit" style={{ display: "none" }} />
      </form>
    </Card>
  );
}

export default AddFeed;
